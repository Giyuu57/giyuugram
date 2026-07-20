import 'package:supabase_flutter/supabase_flutter.dart';

class ReelsRepository {
  final SupabaseClient _client;
  ReelsRepository(this._client);

  Future<List<Map<String, dynamic>>> getReels({
    required String currentUserId,
    int page = 0,
    int pageSize = 5,
  }) async {
    final from = page * pageSize;
    final to = from + pageSize - 1;

    final response = await _client
        .from('posts')
        .select('''
          id, user_id, caption, media_urls, thumbnail_url, type,
          like_count, comment_count, created_at,
          profiles!posts_user_id_fkey(username, avatar_url)
        ''')
        .eq('type', 'reel')
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
    final likedIds =
        List<Map<String, dynamic>>.from(likedRows).map((r) => r['post_id'] as String).toSet();

    final savedRows = await _client
        .from('saved_posts')
        .select('post_id')
        .eq('user_id', currentUserId)
        .inFilter('post_id', postIds);
    final savedIds =
        List<Map<String, dynamic>>.from(savedRows).map((r) => r['post_id'] as String).toSet();

    return rows.map((row) {
      final profile = row['profiles'] as Map<String, dynamic>?;
      return {
        ...row,
        'author_username': profile?['username'],
        'author_avatar_url': profile?['avatar_url'],
        'is_liked_by_me': likedIds.contains(row['id']),
        'is_saved_by_me': savedIds.contains(row['id']),
      };
    }).toList();
  }
}
