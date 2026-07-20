import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/providers.dart';
import '../../../../shared_models/conversation.dart';
import '../../../../shared_models/message.dart';
import '../../data/chat_repository.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.watch(supabaseClientProvider));
});

/// Chat list — conversations for the current user.
class ConversationsController
    extends StateNotifier<AsyncValue<List<Conversation>>> {
  final ChatRepository _repository;
  final String _userId;

  ConversationsController(this._repository, this._userId)
      : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final convos = await _repository.getConversations(_userId);
      state = AsyncValue.data(convos);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() => _load();
}

final conversationsControllerProvider = StateNotifierProvider.autoDispose<
    ConversationsController, AsyncValue<List<Conversation>>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  return ConversationsController(
      ref.watch(chatRepositoryProvider), userId ?? '');
});

/// Total unread message count across all conversations, for a badge.
final unreadMessagesCountProvider =
    FutureProvider.autoDispose<int>((ref) async {
  final convosAsync = ref.watch(conversationsControllerProvider);
  return convosAsync.maybeWhen(
    data: (convos) => convos.fold<int>(0, (sum, c) => sum + c.unreadCount),
    orElse: () => 0,
  );
});

/// Messages within a single conversation, kept live via realtime.
class MessagesController extends StateNotifier<AsyncValue<List<ChatMessage>>> {
  final ChatRepository _repository;
  final String _conversationId;
  StreamSubscription? _sub;

  MessagesController(this._repository, this._conversationId)
      : super(const AsyncValue.loading()) {
    _load();
    _listen();
  }

  Future<void> _load() async {
    try {
      final messages = await _repository.getMessages(_conversationId);
      state = AsyncValue.data(messages);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _listen() {
    _sub = _repository.watchMessages(_conversationId).listen((_) {
      _load();
    });
  }

  Future<void> sendMessage({
    required String senderId,
    String? content,
    String? mediaUrl,
    String messageType = 'text',
    String? sharedPostId,
  }) async {
    await _repository.sendMessage(
      conversationId: _conversationId,
      senderId: senderId,
      content: content,
      mediaUrl: mediaUrl,
      messageType: messageType,
      sharedPostId: sharedPostId,
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final messagesControllerProvider = StateNotifierProvider.autoDispose
    .family<MessagesController, AsyncValue<List<ChatMessage>>, String>(
        (ref, conversationId) {
  return MessagesController(ref.watch(chatRepositoryProvider), conversationId);
});
