// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostImpl _$$PostImplFromJson(Map<String, dynamic> json) => _$PostImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      caption: json['caption'] as String?,
      mediaUrls:
          (json['mediaUrls'] as List<dynamic>).map((e) => e as String).toList(),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      type: json['type'] as String? ?? 'image',
      location: json['location'] as String?,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      authorUsername: json['authorUsername'] as String?,
      authorAvatarUrl: json['authorAvatarUrl'] as String?,
      isLikedByMe: json['isLikedByMe'] as bool? ?? false,
      isSavedByMe: json['isSavedByMe'] as bool? ?? false,
    );

Map<String, dynamic> _$$PostImplToJson(_$PostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'caption': instance.caption,
      'mediaUrls': instance.mediaUrls,
      'thumbnailUrl': instance.thumbnailUrl,
      'type': instance.type,
      'location': instance.location,
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'authorUsername': instance.authorUsername,
      'authorAvatarUrl': instance.authorAvatarUrl,
      'isLikedByMe': instance.isLikedByMe,
      'isSavedByMe': instance.isSavedByMe,
    };
