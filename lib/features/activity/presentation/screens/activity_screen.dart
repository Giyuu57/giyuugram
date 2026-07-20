import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/widgets/profile_avatar.dart';
import '../../../../shared_models/activity.dart';
import '../providers/activity_providers.dart';

class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(activityControllerProvider.notifier).markAllAsRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    final activityState = ref.watch(activityControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Activity')),
      body: RefreshIndicator(
        onRefresh: () => ref.read(activityControllerProvider.notifier).refresh(),
        child: activityState.isLoading && activityState.items.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : activityState.error != null
                ? Center(child: Text('Failed to load activity: ${activityState.error}'))
                : activityState.items.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(height: 120),
                          Center(
                            child: Text(
                              'Activity On Your Posts\n\nWhen people like or comment on your\nposts, you\'ll see it here.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        itemCount: activityState.items.length,
                        itemBuilder: (context, index) {
                          return _ActivityTile(item: activityState.items[index]);
                        },
                      ),
      ),
    );
  }
}

class _ActivityTile extends ConsumerWidget {
  final ActivityItem item;
  const _ActivityTile({required this.item});

  String _messageFor(ActivityItem item) {
    switch (item.type) {
      case 'like':
        return 'liked your post.';
      case 'comment':
        return 'commented on your post.';
      case 'follow':
        return 'started following you.';
      case 'mention':
        return 'mentioned you in a comment.';
      case 'reply':
        return 'replied to your comment.';
      default:
        return 'interacted with your content.';
    }
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'like':
        return Icons.favorite;
      case 'comment':
      case 'reply':
        return Icons.chat_bubble;
      case 'follow':
        return Icons.person_add;
      default:
        return Icons.notifications;
    }
  }

  Color _iconColorFor(String type) {
    switch (type) {
      case 'like':
        return Colors.red;
      case 'follow':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Stack(
        children: [
          ProfileAvatar(
            avatarUrl: item.actorAvatarUrl,
            radius: 22,
            onTap: () =>
                context.pushNamed('user_profile', pathParameters: {'userId': item.actorId}),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: _iconColorFor(item.type),
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
              ),
              child: Icon(_iconFor(item.type), size: 10, color: Colors.white),
            ),
          ),
        ],
      ),
      title: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: '${item.actorUsername ?? 'Someone'} ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: _messageFor(item)),
          ],
        ),
      ),
      subtitle: Text(
        timeago.format(item.createdAt),
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      trailing: item.type == 'follow'
          ? null
          : item.postThumbnailUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: item.postThumbnailUrl!,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                  ),
                )
              : null,
      onTap: () {
        if (item.type == 'follow') {
          context.pushNamed('user_profile', pathParameters: {'userId': item.actorId});
        }
      },
    );
  }
}
