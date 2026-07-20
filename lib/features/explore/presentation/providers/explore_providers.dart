import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/providers.dart';
import '../../data/explore_repository.dart';

final exploreRepositoryProvider = Provider<ExploreRepository>((ref) {
  return ExploreRepository(ref.watch(supabaseClientProvider));
});

final explorePostsProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];
  return ref.watch(exploreRepositoryProvider).getExplorePosts(currentUserId: userId);
});

final searchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

final userSearchResultsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return [];
  await Future.delayed(const Duration(milliseconds: 300));
  if (ref.read(searchQueryProvider) != query) return [];
  return ref.watch(exploreRepositoryProvider).searchUsers(query);
});

final hashtagSearchResultsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return [];
  await Future.delayed(const Duration(milliseconds: 300));
  if (ref.read(searchQueryProvider) != query) return [];
  return ref.watch(exploreRepositoryProvider).searchHashtags(query);
});

final hashtagPostsProvider =
    FutureProvider.autoDispose.family<List<Map<String, dynamic>>, String>((ref, hashtagId) async {
  return ref.watch(exploreRepositoryProvider).getPostsByHashtag(hashtagId);
});
