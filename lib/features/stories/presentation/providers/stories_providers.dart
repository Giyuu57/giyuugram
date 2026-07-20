import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/providers.dart';
import '../../../../shared_models/story.dart';
import '../../data/stories_repository.dart';

final storiesRepositoryProvider = Provider<StoriesRepository>((ref) {
  return StoriesRepository(ref.watch(supabaseClientProvider));
});

final storiesFeedProvider = FutureProvider.autoDispose<List<StoryGroup>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];
  return ref.watch(storiesRepositoryProvider).getStoriesFeed(userId);
});
