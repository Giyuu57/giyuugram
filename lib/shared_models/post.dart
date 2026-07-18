import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
class Post with _$Post {
  const factory Post({
    required String id,
    required String userId,
    String? caption,
    required List<String> mediaUrls,
    String? thumbnailUrl,
    @Default('image') String type,
    String? location,
    @Default(0) int likeCount,
    @Default(0) int commentCount,
    required DateTime createdAt,
    // Joined fields (not columns) — populated by the repository query
    String? authorUsername,
    String? authorAvatarUrl,
    @Default(false) bool isLikedByMe,
    @Default(false) bool isSavedByMe,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}