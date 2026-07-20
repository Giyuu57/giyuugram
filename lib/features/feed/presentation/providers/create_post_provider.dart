import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'feed_providers.dart';

class CreatePostController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  CreatePostController(this._ref) : super(const AsyncValue.data(null));

  Future<bool> submit({
    required String userId,
    required List<File> mediaFiles,
    String? caption,
    String? location,
    String type = 'image',
    String? thumbnailFile,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(feedRepositoryProvider).createPost(
            userId: userId,
            mediaFiles: mediaFiles,
            caption: caption,
            location: location,
            type: type,
            thumbnailFile: thumbnailFile,
          );
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final createPostControllerProvider =
    StateNotifierProvider.autoDispose<CreatePostController, AsyncValue<void>>((ref) {
  return CreatePostController(ref);
});
