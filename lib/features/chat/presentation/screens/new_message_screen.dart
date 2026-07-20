import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/providers.dart';
import '../../../../core/widgets/profile_avatar.dart';
import '../../../explore/presentation/providers/explore_providers.dart';
import '../providers/chat_providers.dart';

/// Simple user search screen used to start a new 1-on-1 conversation.
/// Reuses the same fuzzy-search backend as Explore.
class NewMessageScreen extends ConsumerStatefulWidget {
  const NewMessageScreen({super.key});

  @override
  ConsumerState<NewMessageScreen> createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends ConsumerState<NewMessageScreen> {
  final _searchController = TextEditingController();
  bool _isStarting = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _startConversation(String otherUserId, String otherUsername) async {
    final currentUserId = ref.read(currentUserIdProvider);
    if (currentUserId == null || _isStarting) return;

    setState(() => _isStarting = true);
    try {
      final conversationId = await ref.read(chatRepositoryProvider).getOrCreateOneOnOneConversation(
            currentUserId: currentUserId,
            otherUserId: otherUserId,
          );
      if (mounted) {
        context.pushReplacementNamed(
          'chat_detail',
          pathParameters: {'conversationId': conversationId},
          extra: otherUsername,
        );
      }
    } finally {
      if (mounted) setState(() => _isStarting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(userSearchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
          decoration: const InputDecoration(hintText: 'Search for a user', border: InputBorder.none),
        ),
      ),
      body: _isStarting
          ? const Center(child: CircularProgressIndicator())
          : usersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Search failed: $e')),
              data: (users) {
                if (_searchController.text.trim().isEmpty) {
                  return const Center(
                    child: Text('Search for someone to message', style: TextStyle(color: Colors.grey)),
                  );
                }
                if (users.isEmpty) {
                  return const Center(
                    child: Text('No users found', style: TextStyle(color: Colors.grey)),
                  );
                }
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      leading: ProfileAvatar(avatarUrl: user['avatar_url'], radius: 20),
                      title: Text(user['username'] ?? ''),
                      subtitle: user['full_name'] != null ? Text(user['full_name']) : null,
                      onTap: () => _startConversation(user['id'] as String, user['username'] as String),
                    );
                  },
                );
              },
            ),
    );
  }
}
