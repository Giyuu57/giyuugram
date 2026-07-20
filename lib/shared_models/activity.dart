import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

@freezed
class ActivityItem with _$ActivityItem {
  const factory ActivityItem({
    required String id,
    required String recipientId,
    required String actorId,
    required String type, // 'like' | 'comment' | 'follow' | 'mention' | 'reply'
    String? postId,
    String? commentId,
    @Default(false) bool isRead,
    required DateTime createdAt,
    String? actorUsername,
    String? actorAvatarUrl,
    String? postThumbnailUrl,
  }) = _ActivityItem;

  factory ActivityItem.fromJson(Map<String, dynamic> json) => _$ActivityItemFromJson(json);
}
