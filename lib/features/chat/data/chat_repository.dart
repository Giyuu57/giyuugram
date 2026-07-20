import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared_models/conversation.dart';
import '../../../shared_models/message.dart';

class ChatRepository {
  final SupabaseClient _client;
  ChatRepository(this._client);

  /// Finds an existing 1-on-1 conversation between two users, or creates
  /// one if none exists. Returns the conversation id.
  Future<String> getOrCreateOneOnOneConversation({
    required String currentUserId,
    required String otherUserId,
  }) async {
    // Find conversations the current user is in.
    final myConvos = await _client
        .from('conversation_participants')
        .select('conversation_id')
        .eq('user_id', currentUserId);
    final myConvoIds =
        List<Map<String, dynamic>>.from(myConvos).map((r) => r['conversation_id'] as String).toList();

    if (myConvoIds.isNotEmpty) {
      // Find conversations the other user is also in, among mine, that are
      // NOT group chats.
      final sharedRows = await _client
          .from('conversation_participants')
          .select('conversation_id, conversations!inner(is_group)')
          .eq('user_id', otherUserId)
          .inFilter('conversation_id', myConvoIds);

      final oneOnOne = List<Map<String, dynamic>>.from(sharedRows).firstWhere(
        (row) => (row['conversations'] as Map<String, dynamic>)['is_group'] == false,
        orElse: () => {},
      );

      if (oneOnOne.isNotEmpty) {
        return oneOnOne['conversation_id'] as String;
      }
    }

    // No existing 1-1 conversation — create one.
    final newConvo = await _client
        .from('conversations')
        .insert({'is_group': false})
        .select('id')
        .single();
    final conversationId = newConvo['id'] as String;

    await _client.from('conversation_participants').insert([
      {'conversation_id': conversationId, 'user_id': currentUserId},
      {'conversation_id': conversationId, 'user_id': otherUserId},
    ]);

    return conversationId;
  }

  /// Fetches conversation list for the chat list screen, with the other
  /// participant's info (1-1 only for now) and last message preview.
  Future<List<Conversation>> getConversations(String currentUserId) async {
    final participantRows = await _client
        .from('conversation_participants')
        .select('conversation_id, last_read_at, conversations(id, is_group, group_name, group_avatar_url, created_at, last_message_at)')
        .eq('user_id', currentUserId)
        .order('conversations(last_message_at)', ascending: false);

    final rows = List<Map<String, dynamic>>.from(participantRows);
    if (rows.isEmpty) return [];

    final results = <Conversation>[];

    for (final row in rows) {
      final convo = row['conversations'] as Map<String, dynamic>?;
      if (convo == null) continue;
      final conversationId = convo['id'] as String;
      final isGroup = convo['is_group'] as bool? ?? false;
      final lastReadAt = row['last_read_at'] as String?;

      String? otherUserId;
      String? otherUsername;
      String? otherAvatarUrl;

      if (!isGroup) {
        final otherParticipant = await _client
            .from('conversation_participants')
            .select('user_id, profiles(username, avatar_url)')
            .eq('conversation_id', conversationId)
            .neq('user_id', currentUserId)
            .maybeSingle();

        if (otherParticipant != null) {
          otherUserId = otherParticipant['user_id'] as String;
          final profile = otherParticipant['profiles'] as Map<String, dynamic>?;
          otherUsername = profile?['username'];
          otherAvatarUrl = profile?['avatar_url'];
        }
      }

      final lastMessageRow = await _client
          .from('messages')
          .select('content, message_type, created_at')
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      String? preview;
      if (lastMessageRow != null) {
        final type = lastMessageRow['message_type'] as String?;
        preview = type == 'text'
            ? lastMessageRow['content'] as String?
            : type == 'image'
                ? 'Sent a photo'
                : type == 'video'
                    ? 'Sent a video'
                    : 'Shared a post';
      }

      int unreadCount = 0;
      if (lastReadAt != null) {
        unreadCount = await _client
            .from('messages')
            .count(CountOption.exact)
            .eq('conversation_id', conversationId)
            .gt('created_at', lastReadAt)
            .neq('sender_id', currentUserId);
      }

      results.add(Conversation.fromJson({
        'id': conversationId,
        'isGroup': isGroup,
        'groupName': convo['group_name'],
        'groupAvatarUrl': convo['group_avatar_url'],
        'createdAt': convo['created_at'],
        'lastMessageAt': convo['last_message_at'],
        'otherUserId': otherUserId,
        'otherUsername': otherUsername,
        'otherAvatarUrl': otherAvatarUrl,
        'lastMessagePreview': preview,
        'unreadCount': unreadCount,
      }));
    }

    results.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
    return results;
  }

  Future<List<ChatMessage>> getMessages(String conversationId, {int limit = 100}) async {
    final response = await _client
        .from('messages')
        .select('''
          id, conversation_id, sender_id, content, media_url, message_type,
          shared_post_id, created_at,
          profiles!messages_sender_id_fkey(username, avatar_url)
        ''')
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true)
        .limit(limit);

    return List<Map<String, dynamic>>.from(response).map((row) {
      final profile = row['profiles'] as Map<String, dynamic>?;
      return ChatMessage.fromJson({
        'id': row['id'],
        'conversationId': row['conversation_id'],
        'senderId': row['sender_id'],
        'content': row['content'],
        'mediaUrl': row['media_url'],
        'messageType': row['message_type'],
        'sharedPostId': row['shared_post_id'],
        'createdAt': row['created_at'],
        'senderUsername': profile?['username'],
        'senderAvatarUrl': profile?['avatar_url'],
      });
    }).toList();
  }

  /// Realtime stream of raw message rows for a conversation — used as a
  /// change signal to refetch with full joined sender info.
  Stream<List<Map<String, dynamic>>> watchMessages(String conversationId) {
    return _client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true);
  }

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    String? content,
    String? mediaUrl,
    String messageType = 'text',
    String? sharedPostId,
  }) async {
    await _client.from('messages').insert({
      'conversation_id': conversationId,
      'sender_id': senderId,
      'content': content,
      'media_url': mediaUrl,
      'message_type': messageType,
      'shared_post_id': sharedPostId,
    });

    await _client
        .from('conversations')
        .update({'last_message_at': DateTime.now().toIso8601String()}).eq('id', conversationId);
  }

  Future<void> markConversationRead({
    required String conversationId,
    required String userId,
  }) async {
    await _client
        .from('conversation_participants')
        .update({'last_read_at': DateTime.now().toIso8601String()})
        .eq('conversation_id', conversationId)
        .eq('user_id', userId);
  }
}
