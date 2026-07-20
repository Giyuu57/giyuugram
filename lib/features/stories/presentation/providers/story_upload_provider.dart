import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'stories_providers.dart';

class StoryUploadController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  StoryUploadController(this._ref) : super(const AsyncValue.data(null));

  Future<bool> uploadStory({
    required String userId,
    required File file,
    String mediaType = 'image',
  }) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(storiesRepositoryProvider).createStory(
            userId: userId,
            file: file,
            mediaType: mediaType,
          );
      _ref.invalidate(storiesFeedProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final storyUploadControllerProvider =
    StateNotifierProvider<StoryUploadController, AsyncValue<void>>((ref) {
  return StoryUploadController(ref);
});
