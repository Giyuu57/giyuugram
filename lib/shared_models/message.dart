import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String conversationId,
    required String senderId,
    String? content,
    String? mediaUrl,
    @Default('text') String messageType, // text | image | video | post_share
    String? sharedPostId,
    required DateTime createdAt,
    String? senderUsername,
    String? senderAvatarUrl,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}
