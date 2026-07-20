// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityItemImpl _$$ActivityItemImplFromJson(Map<String, dynamic> json) =>
    _$ActivityItemImpl(
      id: json['id'] as String,
      recipientId: json['recipientId'] as String,
      actorId: json['actorId'] as String,
      type: json['type'] as String,
      postId: json['postId'] as String?,
      commentId: json['commentId'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      actorUsername: json['actorUsername'] as String?,
      actorAvatarUrl: json['actorAvatarUrl'] as String?,
      postThumbnailUrl: json['postThumbnailUrl'] as String?,
    );

Map<String, dynamic> _$$ActivityItemImplToJson(_$ActivityItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'recipientId': instance.recipientId,
      'actorId': instance.actorId,
      'type': instance.type,
      'postId': instance.postId,
      'commentId': instance.commentId,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt.toIso8601String(),
      'actorUsername': instance.actorUsername,
      'actorAvatarUrl': instance.actorAvatarUrl,
      'postThumbnailUrl': instance.postThumbnailUrl,
    };
