import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/providers.dart';
import '../../../auth/domain/app_user.dart';
import '../../data/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(supabaseClientProvider));
});

/// Fetches a profile by userId. `.family` lets us reuse this for any profile,
/// not just the logged-in user (needed when viewing someone else's profile).
final profileProvider =
    FutureProvider.autoDispose.family<AppUser, String>((ref, userId) async {
  return ref.watch(profileRepositoryProvider).getProfile(userId);
});

final userPostsProvider =
    FutureProvider.autoDispose.family<List<Map<String, dynamic>>, String>((ref, userId) async {
  return ref.watch(profileRepositoryProvider).getUserPosts(userId);
});

final savedPostsProvider =
    FutureProvider.autoDispose.family<List<Map<String, dynamic>>, String>((ref, userId) async {
  return ref.watch(profileRepositoryProvider).getSavedPosts(userId);
});

final isFollowingProvider =
    FutureProvider.autoDispose.family<bool, String>((ref, targetUserId) async {
  final currentUserId = ref.watch(currentUserIdProvider);
  if (currentUserId == null || currentUserId == targetUserId) return false;
  return ref
      .watch(profileRepositoryProvider)
      .isFollowing(followerId: currentUserId, followingId: targetUserId);
});

/// Handles follow/unfollow + avatar upload + profile edits with loading state.
class ProfileActionsController extends StateNotifier<AsyncValue<void>> {
  final ProfileRepository _repository;
  final Ref _ref;

  ProfileActionsController(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> toggleFollow({
    required String currentUserId,
    required String targetUserId,
    required bool currentlyFollowing,
  }) async {
    state = const AsyncValue.loading();
    try {
      if (currentlyFollowing) {
        await _repository.unfollow(followerId: currentUserId, followingId: targetUserId);
      } else {
        await _repository.follow(followerId: currentUserId, followingId: targetUserId);
      }
      // Invalidate so both the button state and follower counts refresh.
      _ref.invalidate(isFollowingProvider(targetUserId));
      _ref.invalidate(profileProvider(targetUserId));
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> updateProfile({
    required String userId,
    String? fullName,
    String? username,
    String? bio,
    String? website,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateProfile(
        userId: userId,
        fullName: fullName,
        username: username,
        bio: bio,
        website: website,
      );
      _ref.invalidate(profileProvider(userId));
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> uploadAvatar({required String userId, required File file}) async {
    state = const AsyncValue.loading();
    try {
      await _repository.uploadAvatar(userId: userId, file: file);
      _ref.invalidate(profileProvider(userId));
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final profileActionsControllerProvider =
    StateNotifierProvider<ProfileActionsController, AsyncValue<void>>((ref) {
  return ProfileActionsController(ref.watch(profileRepositoryProvider), ref);
});