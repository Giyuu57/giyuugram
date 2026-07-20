import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/providers.dart';
import '../../data/reels_repository.dart';
import '../../../feed/data/feed_repository.dart';

final reelsRepositoryProvider = Provider<ReelsRepository>((ref) {
  return ReelsRepository(ref.watch(supabaseClientProvider));
});

const _reelsPageSize = 5;

class ReelsState {
  final List<Map<String, dynamic>> reels;
  final bool isLoadingMore;
  final bool hasMore;

  const ReelsState({this.reels = const [], this.isLoadingMore = false, this.hasMore = true});

  ReelsState copyWith({List<Map<String, dynamic>>? reels, bool? isLoadingMore, bool? hasMore}) {
    return ReelsState(
      reels: reels ?? this.reels,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class ReelsController extends StateNotifier<ReelsState> {
  final ReelsRepository _repository;
  final String _currentUserId;
  int _page = 0;

  ReelsController(this._repository, this._currentUserId) : super(const ReelsState()) {
    loadInitial();
  }

  Future<void> loadInitial() async {
    _page = 0;
    state = state.copyWith(isLoadingMore: true);
    final reels = await _repository.getReels(
      currentUserId: _currentUserId,
      page: 0,
      pageSize: _reelsPageSize,
    );
    state = ReelsState(reels: reels, hasMore: reels.length == _reelsPageSize);
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    _page++;
    final newReels = await _repository.getReels(
      currentUserId: _currentUserId,
      page: _page,
      pageSize: _reelsPageSize,
    );
    state = state.copyWith(
      reels: [...state.reels, ...newReels],
      hasMore: newReels.length == _reelsPageSize,
      isLoadingMore: false,
    );
  }

  Future<void> toggleLike(String postId, FeedRepository feedRepository) async {
    final index = state.reels.indexWhere((r) => r['id'] == postId);
    if (index == -1) return;
    final reel = state.reels[index];
    final wasLiked = reel['is_liked_by_me'] as bool;

    final updated = [...state.reels];
    updated[index] = {
      ...reel,
      'is_liked_by_me': !wasLiked,
      'like_count': wasLiked ? (reel['like_count'] as int) - 1 : (reel['like_count'] as int) + 1,
    };
    state = state.copyWith(reels: updated);

    try {
      if (wasLiked) {
        await feedRepository.unlikePost(userId: _currentUserId, postId: postId);
      } else {
        await feedRepository.likePost(userId: _currentUserId, postId: postId);
        await feedRepository.notifyLike(
          actorId: _currentUserId,
          postOwnerId: reel['user_id'] as String,
          postId: postId,
        );
      }
    } catch (e) {
      final rollback = [...state.reels];
      rollback[index] = reel;
      state = state.copyWith(reels: rollback);
    }
  }

  Future<void> toggleSave(String postId, FeedRepository feedRepository) async {
    final index = state.reels.indexWhere((r) => r['id'] == postId);
    if (index == -1) return;
    final reel = state.reels[index];
    final wasSaved = reel['is_saved_by_me'] as bool;

    final updated = [...state.reels];
    updated[index] = {...reel, 'is_saved_by_me': !wasSaved};
    state = state.copyWith(reels: updated);

    try {
      if (wasSaved) {
        await feedRepository.unsavePost(userId: _currentUserId, postId: postId);
      } else {
        await feedRepository.savePost(userId: _currentUserId, postId: postId);
      }
    } catch (e) {
      final rollback = [...state.reels];
      rollback[index] = reel;
      state = state.copyWith(reels: rollback);
    }
  }
}

final reelsControllerProvider =
    StateNotifierProvider.autoDispose<ReelsController, ReelsState>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  return ReelsController(ref.watch(reelsRepositoryProvider), userId ?? '');
});
