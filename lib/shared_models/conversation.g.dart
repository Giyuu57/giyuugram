// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationImpl _$$ConversationImplFromJson(Map<String, dynamic> json) =>
    _$ConversationImpl(
      id: json['id'] as String,
      isGroup: json['isGroup'] as bool? ?? false,
      groupName: json['groupName'] as String?,
      groupAvatarUrl: json['groupAvatarUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastMessageAt: DateTime.parse(json['lastMessageAt'] as String),
      otherUserId: json['otherUserId'] as String?,
      otherUsername: json['otherUsername'] as String?,
      otherAvatarUrl: json['otherAvatarUrl'] as String?,
      lastMessagePreview: json['lastMessagePreview'] as String?,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ConversationImplToJson(_$ConversationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isGroup': instance.isGroup,
      'groupName': instance.groupName,
      'groupAvatarUrl': instance.groupAvatarUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastMessageAt': instance.lastMessageAt.toIso8601String(),
      'otherUserId': instance.otherUserId,
      'otherUsername': instance.otherUsername,
      'otherAvatarUrl': instance.otherAvatarUrl,
      'lastMessagePreview': instance.lastMessagePreview,
      'unreadCount': instance.unreadCount,
    };
