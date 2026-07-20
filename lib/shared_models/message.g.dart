// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      content: json['content'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      messageType: json['messageType'] as String? ?? 'text',
      sharedPostId: json['sharedPostId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      senderUsername: json['senderUsername'] as String?,
      senderAvatarUrl: json['senderAvatarUrl'] as String?,
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'senderId': instance.senderId,
      'content': instance.content,
      'mediaUrl': instance.mediaUrl,
      'messageType': instance.messageType,
      'sharedPostId': instance.sharedPostId,
      'createdAt': instance.createdAt.toIso8601String(),
      'senderUsername': instance.senderUsername,
      'senderAvatarUrl': instance.senderAvatarUrl,
    };
