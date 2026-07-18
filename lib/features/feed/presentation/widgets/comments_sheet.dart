import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/services/providers.dart';
import '../../../../core/widgets/profile_avatar.dart';
import '../../../../shared_models/post.dart';
import '../providers/feed_providers.dart';

class CommentsSheet extends ConsumerStatefulWidget {
  final Post post;
  const CommentsSheet({super.key, required this.post});

  @override
  ConsumerState<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends ConsumerState<CommentsSheet> {
  final _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    setState(() => _isSubmitting = true);
    try {
      await ref.read(feedRepositoryProvider).addComment(
            postId: widget.post.id,
            userId: userId,
            content: text,
            postOwnerId: widget.post.userId,
          );
      ref.read(feedControllerProvider.notifier).incrementCommentCount(widget.post.id);
      ref.invalidate(commentsProvider(widget.post.id));
      _commentController.clear();
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsync = ref.watch(commentsProvider(widget.post.id));

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Comments', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1),
              Expanded(
                child: commentsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Center(child: Text('Failed to load comments: $e')),
                  data: (comments) {
                    if (comments.isEmpty) {
                      return const Center(
                        child: Text('No comments yet.\nBe the first to comment!',
                            textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                      );
                    }
                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProfileAvatar(avatarUrl: comment.authorAvatarUrl, radius: 16),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: DefaultTextStyle.of(context).style,
                                        children: [
                                          TextSpan(
                                            text: '${comment.authorUsername} ',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(text: comment.content),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      timeago.format(comment.createdAt),
                                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            hintText: 'Add a comment...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : TextButton(
                              onPressed: _submitComment,
                              child: const Text('Post', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}