import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared_models/story.dart';

class StoriesRepository {
  final SupabaseClient _client;
  StoriesRepository(this._client);

  /// Fetches active (non-expired) stories from followed users + self,
  /// grouped by author for the horizontal stories row.
  Future<List<StoryGroup>> getStoriesFeed(String currentUserId) async {
    final followingRows = await _client
        .from('follows')
        .select('following_id')
        .eq('follower_id', currentUserId);

    final followingIds = List<Map<String, dynamic>>.from(followingRows)
        .map((r) => r['following_id'] as String)
        .toList()
      ..add(currentUserId);

    final response = await _client
        .from('stories')
        .select('''
          id, user_id, media_url, media_type, created_at, expires_at,
          profiles!stories_user_id_fkey(username, avatar_url)
        ''')
        .inFilter('user_id', followingIds)
        .gt('expires_at', DateTime.now().toIso8601String())
        .order('created_at', ascending: true);

    final rows = List<Map<String, dynamic>>.from(response);
    if (rows.isEmpty) return [];

    final storyIds = rows.map((r) => r['id'] as String).toList();
    final viewedRows = await _client
        .from('story_views')
        .select('story_id')
        .eq('viewer_id', currentUserId)
        .inFilter('story_id', storyIds);
    final viewedIds =
        List<Map<String, dynamic>>.from(viewedRows).map((r) => r['story_id'] as String).toSet();

    // Group by user_id, preserving self first, then most recent story activity.
    final Map<String, List<Story>> grouped = {};
    final Map<String, Map<String, dynamic>> profileByUser = {};

    for (final row in rows) {
      final uid = row['user_id'] as String;
      final profile = row['profiles'] as Map<String, dynamic>?;
      profileByUser[uid] = profile ?? {};

      final story = Story.fromJson({
        'id': row['id'],
        'userId': uid,
        'mediaUrl': row['media_url'],
        'mediaType': row['media_type'],
        'createdAt': row['created_at'],
        'expiresAt': row['expires_at'],
        'isViewedByMe': viewedIds.contains(row['id']),
      });

      grouped.putIfAbsent(uid, () => []).add(story);
    }

    final groups = grouped.entries.map((entry) {
      final profile = profileByUser[entry.key]!;
      return StoryGroup(
        userId: entry.key,
        username: profile['username'] ?? '',
        avatarUrl: profile['avatar_url'],
        stories: entry.value,
      );
    }).toList();

    // Self first, then unseen-before-seen, mimicking Instagram ordering.
    groups.sort((a, b) {
      if (a.userId == currentUserId) return -1;
      if (b.userId == currentUserId) return 1;
      final aUnseen = a.stories.any((s) => !s.isViewedByMe);
      final bUnseen = b.stories.any((s) => !s.isViewedByMe);
      if (aUnseen == bUnseen) return 0;
      return aUnseen ? -1 : 1;
    });

    return groups;
  }

  Future<void> markStoryViewed({required String storyId, required String viewerId}) async {
    await _client.from('story_views').upsert({
      'story_id': storyId,
      'viewer_id': viewerId,
    });
  }
}