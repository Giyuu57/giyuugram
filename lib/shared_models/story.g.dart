// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoryImpl _$$StoryImplFromJson(Map<String, dynamic> json) => _$StoryImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      mediaUrl: json['mediaUrl'] as String,
      mediaType: json['mediaType'] as String? ?? 'image',
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      authorUsername: json['authorUsername'] as String?,
      authorAvatarUrl: json['authorAvatarUrl'] as String?,
      isViewedByMe: json['isViewedByMe'] as bool? ?? false,
    );

Map<String, dynamic> _$$StoryImplToJson(_$StoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'mediaUrl': instance.mediaUrl,
      'mediaType': instance.mediaType,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
      'authorUsername': instance.authorUsername,
      'authorAvatarUrl': instance.authorAvatarUrl,
      'isViewedByMe': instance.isViewedByMe,
    };
