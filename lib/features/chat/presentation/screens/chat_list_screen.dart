import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/widgets/profile_avatar.dart';
import '../providers/chat_providers.dart';
import 'new_message_screen.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(conversationsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const NewMessageScreen()),
            ),
          ),
        ],
      ),
      body: conversationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Failed to load messages: $e')),
        data: (conversations) {
          if (conversations.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No messages yet.\nStart a conversation from someone\'s profile!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(conversationsControllerProvider.notifier).refresh(),
            child: ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final convo = conversations[index];
                final title = convo.isGroup ? (convo.groupName ?? 'Group') : (convo.otherUsername ?? 'User');
                final avatarUrl = convo.isGroup ? convo.groupAvatarUrl : convo.otherAvatarUrl;

                return ListTile(
                  leading: ProfileAvatar(avatarUrl: avatarUrl, radius: 26),
                  title: Text(
                    title,
                    style: TextStyle(
                      fontWeight: convo.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    convo.lastMessagePreview ?? 'Say hi!',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: convo.unreadCount > 0 ? null : Colors.grey,
                      fontWeight: convo.unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        timeago.format(convo.lastMessageAt, locale: 'en_short'),
                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                      if (convo.unreadCount > 0) ...[
                        const SizedBox(height: 4),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  onTap: () => context.pushNamed(
                    'chat_detail',
                    pathParameters: {'conversationId': convo.id},
                    extra: title,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
