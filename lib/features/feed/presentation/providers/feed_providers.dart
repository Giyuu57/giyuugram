import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/providers.dart';
import '../../../../shared_models/post.dart';
import '../../../../shared_models/comment.dart';
import '../../data/feed_repository.dart';

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return FeedRepository(ref.watch(supabaseClientProvider));
});

const _pageSize = 10;

/// Paginated feed state — holds accumulated posts + pagination status.
class FeedState {
  final List<Post> posts;
  final bool isLoadingMore;
  final bool hasMore;
  final Object? error;

  const FeedState({
    this.posts = const [],
    this.isLoadingMore = false,
    this.hasMore = true,
    this.error,
  });

  FeedState copyWith({
    List<Post>? posts,
    bool? isLoadingMore,
    bool? hasMore,
    Object? error,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }
}

class FeedController extends StateNotifier<FeedState> {
  final FeedRepository _repository;
  final String _currentUserId;
  int _page = 0;

  FeedController(this._repository, this._currentUserId) : super(const FeedState()) {
    loadInitial();
  }

  Future<void> loadInitial() async {
    _page = 0;
    state = state.copyWith(isLoadingMore: true, error: null);
    try {
      final posts = await _repository.getFeedPosts(
        currentUserId: _currentUserId,
        page: 0,
        pageSize: _pageSize,
      );
      state = FeedState(
        posts: posts,
        hasMore: posts.length == _pageSize,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e);
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      _page++;
      final newPosts = await _repository.getFeedPosts(
        currentUserId: _currentUserId,
        page: _page,
        pageSize: _pageSize,
      );
      state = state.copyWith(
        posts: [...state.posts, ...newPosts],
        hasMore: newPosts.length == _pageSize,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e);
    }
  }

  Future<void> refresh() => loadInitial();

  /// Optimistic like toggle — updates UI instantly, rolls back on failure.
  Future<void> toggleLike(String postId) async {
    final index = state.posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;
    final post = state.posts[index];
    final wasLiked = post.isLikedByMe;

    final updated = [...state.posts];
    updated[index] = post.copyWith(
      isLikedByMe: !wasLiked,
      likeCount: wasLiked ? post.likeCount - 1 : post.likeCount + 1,
    );
    state = state.copyWith(posts: updated);

    try {
      if (wasLiked) {
        await _repository.unlikePost(userId: _currentUserId, postId: postId);
      } else {
        await _repository.likePost(userId: _currentUserId, postId: postId);
        await _repository.notifyLike(
          actorId: _currentUserId,
          postOwnerId: post.userId,
          postId: postId,
        );
      }
    } catch (e) {
      // Roll back on failure.
      final rollback = [...state.posts];
      rollback[index] = post;
      state = state.copyWith(posts: rollback);
    }
  }

  Future<void> toggleSave(String postId) async {
    final index = state.posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;
    final post = state.posts[index];
    final wasSaved = post.isSavedByMe;

    final updated = [...state.posts];
    updated[index] = post.copyWith(isSavedByMe: !wasSaved);
    state = state.copyWith(posts: updated);

    try {
      if (wasSaved) {
        await _repository.unsavePost(userId: _currentUserId, postId: postId);
      } else {
        await _repository.savePost(userId: _currentUserId, postId: postId);
      }
    } catch (e) {
      final rollback = [...state.posts];
      rollback[index] = post;
      state = state.copyWith(posts: rollback);
    }
  }

  void incrementCommentCount(String postId) {
    final index = state.posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;
    final updated = [...state.posts];
    updated[index] = updated[index].copyWith(
      commentCount: updated[index].commentCount + 1,
    );
    state = state.copyWith(posts: updated);
  }
}

final feedControllerProvider =
    StateNotifierProvider.autoDispose<FeedController, FeedState>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  return FeedController(ref.watch(feedRepositoryProvider), userId ?? '');
});

/// Comments for a specific post — loaded on-demand when the sheet opens.
final commentsProvider =
    FutureProvider.autoDispose.family<List<Comment>, String>((ref, postId) async {
  return ref.watch(feedRepositoryProvider).getComments(postId);
});