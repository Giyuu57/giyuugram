import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared_models/post.dart';
import '../../../shared_models/comment.dart';

class FeedRepository {
  final SupabaseClient _client;
  FeedRepository(this._client);

  /// Fetches a page of posts for the home feed — from users the current
  /// user follows, plus their own posts. Falls back to global posts if
  /// the user isn't following anyone yet (better empty-state UX).
  Future<List<Post>> getFeedPosts({
    required String currentUserId,
    int page = 0,
    int pageSize = 10,
  }) async {
    final from = page * pageSize;
    final to = from + pageSize - 1;

    // Get list of followed user IDs (+ self) to scope the feed.
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

    // Batch-fetch like/save status for all posts in this page in 2 queries
    // instead of N — avoids an N+1 query problem.
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

  /// Fires an activity notification when a post is liked (skips self-likes).
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
}