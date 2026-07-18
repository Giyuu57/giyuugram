// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentImpl _$$CommentImplFromJson(Map<String, dynamic> json) =>
    _$CommentImpl(
      id: json['id'] as String,
      postId: json['postId'] as String,
      userId: json['userId'] as String,
      parentId: json['parentId'] as String?,
      content: json['content'] as String,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      authorUsername: json['authorUsername'] as String?,
      authorAvatarUrl: json['authorAvatarUrl'] as String?,
      isLikedByMe: json['isLikedByMe'] as bool? ?? false,
    );

Map<String, dynamic> _$$CommentImplToJson(_$CommentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'userId': instance.userId,
      'parentId': instance.parentId,
      'content': instance.content,
      'likeCount': instance.likeCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'authorUsername': instance.authorUsername,
      'authorAvatarUrl': instance.authorAvatarUrl,
      'isLikedByMe': instance.isLikedByMe,
    };
