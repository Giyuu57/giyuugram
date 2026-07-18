import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/providers.dart';
import '../../../../core/widgets/profile_avatar.dart';
import '../../../../core/widgets/stories_row_skeleton.dart';
import '../providers/stories_providers.dart';
import 'package:giyuugram/features/stories/presentation/screens/story_viewer_screen.dart';

class StoriesRow extends ConsumerWidget {
  const StoriesRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(storiesFeedProvider);
    final currentUserId = ref.watch(currentUserIdProvider);

    return storiesAsync.when(
      loading: () => const StoriesRowSkeleton(),
      error: (e, st) => const SizedBox(height: 100),
      data: (groups) {
        return SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: groups.length + 1, // +1 for "Your Story" add button
            itemBuilder: (context, index) {
              if (index == 0) {
                final hasOwnStory = groups.isNotEmpty && groups.first.userId == currentUserId;
                return _AddOrOwnStoryTile(
                  hasOwnStory: hasOwnStory,
                  group: hasOwnStory ? groups.first : null,
                  onTap: () {
                    if (hasOwnStory) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => StoryViewerScreen(groups: groups, initialIndex: 0),
                      ));
                    } else {
                      // Navigate to create-story flow — wired in Phase 6.
                    }
                  },
                );
              }

              final groupIndex = groups.first.userId == currentUserId ? index - 1 : index - 1;
              final adjustedGroups =
                  groups.first.userId == currentUserId ? groups.sublist(1) : groups;
              if (groupIndex >= adjustedGroups.length) return const SizedBox.shrink();

              final group = adjustedGroups[groupIndex];
              return _StoryTile(
                group: group,
                onTap: () {
                  final fullIndex = groups.indexOf(group);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => StoryViewerScreen(groups: groups, initialIndex: fullIndex),
                  ));
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _AddOrOwnStoryTile extends StatelessWidget {
  final bool hasOwnStory;
  final dynamic group;
  final VoidCallback onTap;

  const _AddOrOwnStoryTile({required this.hasOwnStory, this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Stack(
              children: [
                ProfileAvatar(
                  avatarUrl: hasOwnStory ? group.avatarUrl : null,
                  radius: 32,
                  showStoryRing: hasOwnStory,
                ),
                if (!hasOwnStory)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 2,
                        ),
                      ),
                      child: const Icon(Icons.add, size: 14, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              hasOwnStory ? 'Your story' : 'Your story',
              style: const TextStyle(fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryTile extends StatelessWidget {
  final dynamic group;
  final VoidCallback onTap;

  const _StoryTile({required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasUnseen = group.stories.any((s) => !s.isViewedByMe);
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            ProfileAvatar(
              avatarUrl: group.avatarUrl,
              radius: 32,
              showStoryRing: hasUnseen,
            ),
            const SizedBox(height: 4),
            Text(
              group.username,
              style: const TextStyle(fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}