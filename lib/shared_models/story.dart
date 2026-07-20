import 'package:freezed_annotation/freezed_annotation.dart';

part 'story.freezed.dart';
part 'story.g.dart';

@freezed
class Story with _$Story {
  const factory Story({
    required String id,
    required String userId,
    required String mediaUrl,
    @Default('image') String mediaType,
    required DateTime createdAt,
    required DateTime expiresAt,
    String? authorUsername,
    String? authorAvatarUrl,
    @Default(false) bool isViewedByMe,
  }) = _Story;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
}

/// Groups a user's stories together for the horizontal stories row.
@freezed
class StoryGroup with _$StoryGroup {
  const factory StoryGroup({
    required String userId,
    required String username,
    String? avatarUrl,
    required List<Story> stories,
  }) = _StoryGroup;
}
