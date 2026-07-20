import 'package:supabase_flutter/supabase_flutter.dart';

class ExploreRepository {
  final SupabaseClient _client;
  ExploreRepository(this._client);

  Future<List<Map<String, dynamic>>> getExplorePosts({
    required String currentUserId,
    int page = 0,
    int pageSize = 30,
  }) async {
    final from = page * pageSize;
    final to = from + pageSize - 1;
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7)).toIso8601String();

    final response = await _client
        .from('posts')
        .select('id, media_urls, thumbnail_url, type, like_count, comment_count, user_id')
        .neq('user_id', currentUserId)
        .gte('created_at', sevenDaysAgo)
        .order('like_count', ascending: false)
        .range(from, to);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query, {int limit = 20}) async {
    if (query.trim().isEmpty) return [];
    final response = await _client
        .from('profiles')
        .select('id, username, full_name, avatar_url')
        .ilike('username', '%$query%')
        .limit(limit);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> searchHashtags(String query, {int limit = 20}) async {
    if (query.trim().isEmpty) return [];
    final response = await _client
        .from('hashtags')
        .select('id, tag')
        .ilike('tag', '%$query%')
        .limit(limit);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getPostsByHashtag(String hashtagId, {int limit = 30}) async {
    final response = await _client
        .from('post_hashtags')
        .select('posts(id, media_urls, thumbnail_url, type, like_count, comment_count, user_id)')
        .eq('hashtag_id', hashtagId)
        .limit(limit);

    return List<Map<String, dynamic>>.from(
      response.map((row) => row['posts'] as Map<String, dynamic>),
    );
  }
}
