import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared_models/activity.dart';

class ActivityRepository {
  final SupabaseClient _client;
  ActivityRepository(this._client);

  Future<List<ActivityItem>> getActivities(String userId, {int limit = 50}) async {
    final response = await _client
        .from('activities')
        .select('''
          id, recipient_id, actor_id, type, post_id, comment_id, is_read, created_at,
          profiles!activities_actor_id_fkey(username, avatar_url),
          posts(thumbnail_url, media_urls)
        ''')
        .eq('recipient_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);

    return List<Map<String, dynamic>>.from(response).map((row) {
      final actor = row['profiles'] as Map<String, dynamic>?;
      final post = row['posts'] as Map<String, dynamic>?;
      final mediaUrls = post != null ? List<String>.from(post['media_urls'] ?? []) : <String>[];

      return ActivityItem.fromJson({
        'id': row['id'],
        'recipientId': row['recipient_id'],
        'actorId': row['actor_id'],
        'type': row['type'],
        'postId': row['post_id'],
        'commentId': row['comment_id'],
        'isRead': row['is_read'],
        'createdAt': row['created_at'],
        'actorUsername': actor?['username'],
        'actorAvatarUrl': actor?['avatar_url'],
        'postThumbnailUrl': post?['thumbnail_url'] ?? (mediaUrls.isNotEmpty ? mediaUrls.first : null),
      });
    }).toList();
  }

  Stream<List<Map<String, dynamic>>> watchNewActivities(String userId) {
    return _client
        .from('activities')
        .stream(primaryKey: ['id'])
        .eq('recipient_id', userId)
        .order('created_at', ascending: false)
        .limit(50);
  }

  Future<void> markAllAsRead(String userId) async {
    await _client.from('activities').update({'is_read': true}).eq('recipient_id', userId);
  }

  Future<int> getUnreadCount(String userId) async {
    final count = await _client
        .from('activities')
        .count(CountOption.exact)
        .eq('recipient_id', userId)
        .eq('is_read', false);
    return count;
  }
}
