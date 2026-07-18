import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment.freezed.dart';
part 'comment.g.dart';

@freezed
class Comment with _$Comment {
  const factory Comment({
    required String id,
    required String postId,
    required String userId,
    String? parentId,
    required String content,
    @Default(0) int likeCount,
    required DateTime createdAt,
    String? authorUsername,
    String? authorAvatarUrl,
    @Default(false) bool isLikedByMe,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
}