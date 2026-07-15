import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../auth/domain/app_user.dart';

class ProfileRepository {
  final SupabaseClient _client;
  ProfileRepository(this._client);

  /// Fetch a single profile with computed follower/following/post counts.
  Future<AppUser> getProfile(String userId) async {
    final profileRow = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    final followerCount = await _client
        .from('follows')
        .count(CountOption.exact)
        .eq('following_id', userId);

    final followingCount = await _client
        .from('follows')
        .count(CountOption.exact)
        .eq('follower_id', userId);

    final postCount = await _client
        .from('posts')
        .count(CountOption.exact)
        .eq('user_id', userId);

    return AppUser.fromJson({
      ...profileRow,
      'followerCount': followerCount,
      'followingCount': followingCount,
      'postCount': postCount,
    });
  }

  /// Grid of a user's own posts (id + first media thumbnail only — fast query).
  Future<List<Map<String, dynamic>>> getUserPosts(
    String userId, {
    int page = 0,
    int pageSize = 24,
  }) async {
    final from = page * pageSize;
    final to = from + pageSize - 1;

    final response = await _client
        .from('posts')
        .select('id, media_urls, thumbnail_url, type, like_count, comment_count')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .range(from, to);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Grid of posts a user has saved.
  Future<List<Map<String, dynamic>>> getSavedPosts(
    String userId, {
    int page = 0,
    int pageSize = 24,
  }) async {
    final from = page * pageSize;
    final to = from + pageSize - 1;

    final response = await _client
        .from('saved_posts')
        .select('posts(id, media_urls, thumbnail_url, type, like_count, comment_count)')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .range(from, to);

    return List<Map<String, dynamic>>.from(
      response.map((row) => row['posts'] as Map<String, dynamic>),
    );
  }

  Future<bool> isFollowing({required String followerId, required String followingId}) async {
    final result = await _client
        .from('follows')
        .select()
        .eq('follower_id', followerId)
        .eq('following_id', followingId)
        .maybeSingle();
    return result != null;
  }

  Future<void> follow({required String followerId, required String followingId}) async {
    await _client.from('follows').insert({
      'follower_id': followerId,
      'following_id': followingId,
    });

    // Fire an activity notification for the followed user.
    await _client.from('activities').insert({
      'recipient_id': followingId,
      'actor_id': followerId,
      'type': 'follow',
    });
  }

  Future<void> unfollow({required String followerId, required String followingId}) async {
    await _client
        .from('follows')
        .delete()
        .eq('follower_id', followerId)
        .eq('following_id', followingId);
  }

  Future<void> updateProfile({
    required String userId,
    String? fullName,
    String? username,
    String? bio,
    String? website,
    bool? isPrivate,
  }) async {
    final updates = <String, dynamic>{'updated_at': DateTime.now().toIso8601String()};
    if (fullName != null) updates['full_name'] = fullName;
    if (username != null) updates['username'] = username;
    if (bio != null) updates['bio'] = bio;
    if (website != null) updates['website'] = website;
    if (isPrivate != null) updates['is_private'] = isPrivate;

    await _client.from('profiles').update(updates).eq('id', userId);
  }

  /// Uploads a new avatar image to Storage and updates the profile row.
  Future<String> uploadAvatar({required String userId, required File file}) async {
    final ext = file.path.split('.').last;
    final fileName = '${const Uuid().v4()}.$ext';
    final storagePath = '$userId/$fileName';

    await _client.storage.from('avatars').upload(
          storagePath,
          file,
          fileOptions: const FileOptions(upsert: true),
        );

    final publicUrl = _client.storage.from('avatars').getPublicUrl(storagePath);

    await _client.from('profiles').update({
      'avatar_url': publicUrl,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);

    return publicUrl;
  }

  Future<bool> isUsernameAvailable(String username, {required String excludingUserId}) async {
    final result = await _client
        .from('profiles')
        .select('id')
        .eq('username', username)
        .neq('id', excludingUserId)
        .maybeSingle();
    return result == null;
  }
}