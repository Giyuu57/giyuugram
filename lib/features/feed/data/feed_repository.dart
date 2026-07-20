import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import '../../../shared_models/post.dart';
import '../../../shared_models/comment.dart';

class FeedRepository {
  final SupabaseClient _client;
  FeedRepository(this._client);

  Future<List<Post>> getFeedPosts({
    required String currentUserId,
    int page = 0,
    int pageSize = 10,
  }) async {
    final from = page * pageSize;
    final to = from + pageSize - 1;

    final followingRows = await _client
        .from('follows')
        .select('following_id')
        .eq('follower_id', currentUserId);

    final followingIds = List<Map<String, dynamic>>.from(followingRows)
        .map((r) => r['following_id'] as String)
        .toList()
      ..add(currentUserId);

    final response = await _client
        .from('posts')
        .select('''
          id, user_id, caption, media_urls, thumbnail_url, type, location,
          like_count, comment_count, created_at,
          profiles!posts_user_id_fkey(username, avatar_url)
        ''')
        .inFilter('user_id', followingIds)
        .order('created_at', ascending: false)
        .range(from, to);

    final rows = List<Map<String, dynamic>>.from(response);
    if (rows.isEmpty) return [];

    final postIds = rows.map((r) => r['id'] as String).toList();

    final likedRows = await _client
        .from('likes')
        .select('post_id')
        .eq('user_id', currentUserId)
        .inFilter('post_id', postIds);
    final likedPostIds =
        List<Map<String, dynamic>>.from(likedRows).map((r) => r['post_id'] as String).toSet();

    final savedRows = await _client
        .from('saved_posts')
        .select('post_id')
        .eq('user_id', currentUserId)
        .inFilter('post_id', postIds);
    final savedPostIds =
        List<Map<String, dynamic>>.from(savedRows).map((r) => r['post_id'] as String).toSet();

    return rows.map((row) {
      final profile = row['profiles'] as Map<String, dynamic>?;
      return Post.fromJson({
        'id': row['id'],
        'userId': row['user_id'],
        'caption': row['caption'],
        'mediaUrls': List<String>.from(row['media_urls'] ?? []),
        'thumbnailUrl': row['thumbnail_url'],
        'type': row['type'],
        'location': row['location'],
        'likeCount': row['like_count'],
        'commentCount': row['comment_count'],
        'createdAt': row['created_at'],
        'authorUsername': profile?['username'],
        'authorAvatarUrl': profile?['avatar_url'],
        'isLikedByMe': likedPostIds.contains(row['id']),
        'isSavedByMe': savedPostIds.contains(row['id']),
      });
    }).toList();
  }

  Future<void> likePost({required String userId, required String postId}) async {
    await _client.from('likes').insert({'user_id': userId, 'post_id': postId});
  }

  Future<void> unlikePost({required String userId, required String postId}) async {
    await _client.from('likes').delete().eq('user_id', userId).eq('post_id', postId);
  }

  Future<void> savePost({required String userId, required String postId}) async {
    await _client.from('saved_posts').insert({'user_id': userId, 'post_id': postId});
  }

  Future<void> unsavePost({required String userId, required String postId}) async {
    await _client.from('saved_posts').delete().eq('user_id', userId).eq('post_id', postId);
  }

  Future<void> notifyLike({
    required String actorId,
    required String postOwnerId,
    required String postId,
  }) async {
    if (actorId == postOwnerId) return;
    await _client.from('activities').insert({
      'recipient_id': postOwnerId,
      'actor_id': actorId,
      'type': 'like',
      'post_id': postId,
    });
  }

  Future<List<Comment>> getComments(String postId) async {
    final response = await _client
        .from('comments')
        .select('''
          id, post_id, user_id, parent_id, content, like_count, created_at,
          profiles!comments_user_id_fkey(username, avatar_url)
        ''')
        .eq('post_id', postId)
        .order('created_at', ascending: true);

    return List<Map<String, dynamic>>.from(response).map((row) {
      final profile = row['profiles'] as Map<String, dynamic>?;
      return Comment.fromJson({
        'id': row['id'],
        'postId': row['post_id'],
        'userId': row['user_id'],
        'parentId': row['parent_id'],
        'content': row['content'],
        'likeCount': row['like_count'],
        'createdAt': row['created_at'],
        'authorUsername': profile?['username'],
        'authorAvatarUrl': profile?['avatar_url'],
      });
    }).toList();
  }

  Future<void> addComment({
    required String postId,
    required String userId,
    required String content,
    required String postOwnerId,
    String? parentId,
  }) async {
    await _client.from('comments').insert({
      'post_id': postId,
      'user_id': userId,
      'content': content,
      'parent_id': parentId,
    });

    if (userId != postOwnerId) {
      await _client.from('activities').insert({
        'recipient_id': postOwnerId,
        'actor_id': userId,
        'type': 'comment',
        'post_id': postId,
      });
    }
  }

  Future<void> deleteComment(String commentId) async {
    await _client.from('comments').delete().eq('id', commentId);
  }

  /// Uploads one or more media files to Storage and creates the post row,
  /// parsing + linking any #hashtags found in the caption.
  Future<String> createPost({
    required String userId,
    required List<File> mediaFiles,
    String? caption,
    String? location,
    String type = 'image', // 'image' | 'video' | 'reel'
    String? thumbnailFile,
  }) async {
    final mediaUrls = <String>[];

    for (final file in mediaFiles) {
      final ext = file.path.split('.').last;
      final fileName = '${const Uuid().v4()}.$ext';
      final storagePath = '$userId/$fileName';

      await _client.storage.from('posts').upload(
            storagePath,
            file,
            fileOptions: const FileOptions(upsert: true),
          );

      mediaUrls.add(_client.storage.from('posts').getPublicUrl(storagePath));
    }

    String? thumbnailUrl;
    if (thumbnailFile != null) {
      final thumbFile = File(thumbnailFile);
      final thumbName = '${const Uuid().v4()}_thumb.jpg';
      final thumbPath = '$userId/$thumbName';
      await _client.storage.from('posts').upload(
            thumbPath,
            thumbFile,
            fileOptions: const FileOptions(upsert: true),
          );
      thumbnailUrl = _client.storage.from('posts').getPublicUrl(thumbPath);
    }

    final postRow = await _client
        .from('posts')
        .insert({
          'user_id': userId,
          'caption': caption,
          'media_urls': mediaUrls,
          'thumbnail_url': thumbnailUrl ?? (type == 'image' ? mediaUrls.first : null),
          'type': type,
          'location': location,
        })
        .select('id')
        .single();

    final postId = postRow['id'] as String;

    if (caption != null && caption.isNotEmpty) {
      await _linkHashtags(postId: postId, caption: caption);
    }

    return postId;
  }

  Future<void> _linkHashtags({required String postId, required String caption}) async {
    final matches = RegExp(r'#(\w+)').allMatches(caption);
    final tags = matches.map((m) => m.group(1)!.toLowerCase()).toSet();
    if (tags.isEmpty) return;

    for (final tag in tags) {
      final existing = await _client
          .from('hashtags')
          .select('id')
          .eq('tag', tag)
          .maybeSingle();

      String hashtagId;
      if (existing != null) {
        hashtagId = existing['id'] as String;
      } else {
        final inserted = await _client
            .from('hashtags')
            .insert({'tag': tag})
            .select('id')
            .single();
        hashtagId = inserted['id'] as String;
      }

      await _client.from('post_hashtags').insert({
        'post_id': postId,
        'hashtag_id': hashtagId,
      });
    }
  }

  Future<void> deletePost(String postId) async {
    await _client.from('posts').delete().eq('id', postId);
  }

  /// Generates a thumbnail from a local video file's first frame and
  /// returns the local file path.
  Future<String?> generateVideoThumbnail(String videoPath) async {
    final thumbPath = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 720,
      quality: 75,
    );
    return thumbPath;
  }
}
