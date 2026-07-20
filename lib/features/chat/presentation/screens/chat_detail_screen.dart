import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/services/providers.dart';
import '../providers/chat_providers.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  final String conversationId;
  final String? title;

  const ChatDetailScreen({super.key, required this.conversationId, this.title});

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = ref.read(currentUserIdProvider);
      if (userId != null) {
        ref.read(chatRepositoryProvider).markConversationRead(
              conversationId: widget.conversationId,
              userId: userId,
            );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendTextMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    _messageController.clear();
    await ref.read(messagesControllerProvider(widget.conversationId).notifier).sendMessage(
          senderId: userId,
          content: text,
          messageType: 'text',
        );
    _scrollToBottom();
  }

  Future<void> _sendImageMessage() async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;

    setState(() => _isSending = true);
    try {
      final file = File(picked.path);
      final ext = file.path.split('.').last;
      final fileName = '${const Uuid().v4()}.$ext';
      final storagePath = '$userId/$fileName';
      final client = ref.read(supabaseClientProvider);

      await client.storage.from('chat-media').upload(storagePath, file);
      final url = await client.storage.from('chat-media').createSignedUrl(storagePath, 60 * 60 * 24 * 7);

      await ref.read(messagesControllerProvider(widget.conversationId).notifier).sendMessage(
            senderId: userId,
            mediaUrl: url,
            messageType: 'image',
          );
      _scrollToBottom();
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(currentUserIdProvider);
    final messagesAsync = ref.watch(messagesControllerProvider(widget.conversationId));

    return Scaffold(
      appBar: AppBar(title: Text(widget.title ?? 'Chat')),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Failed to load messages: $e')),
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(
                    child: Text('No messages yet.\nSay hello!',
                        textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                  );
                }
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == currentUserId;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: message.messageType == 'image'
                            ? const EdgeInsets.all(4)
                            : const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        decoration: BoxDecoration(
                          color: isMe
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: message.messageType == 'image' && message.mediaUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: message.mediaUrl!,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Text(
                                message.content ?? '',
                                style: TextStyle(
                                  color: isMe ? Colors.white : Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: _isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.image_outlined),
                    onPressed: _isSending ? null : _sendImageMessage,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Message...',
                        filled: true,
                        fillColor: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF262626)
                            : const Color(0xFFF0F0F0),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendTextMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendTextMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
