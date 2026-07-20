import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    required String id,
    @Default(false) bool isGroup,
    String? groupName,
    String? groupAvatarUrl,
    required DateTime createdAt,
    required DateTime lastMessageAt,
    // Joined/derived fields for the chat list UI
    String? otherUserId,
    String? otherUsername,
    String? otherAvatarUrl,
    String? lastMessagePreview,
    @Default(0) int unreadCount,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) => _$ConversationFromJson(json);
}
