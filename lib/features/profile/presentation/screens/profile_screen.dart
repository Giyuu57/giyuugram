import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/providers.dart';
import '../../../../core/widgets/profile_avatar.dart';
import '../../../../core/widgets/stat_column.dart';
import '../../../../core/widgets/post_grid.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../providers/profile_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String? userId;
  const ProfileScreen({super.key, this.userId});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(currentUserIdProvider);
    final profileUserId = widget.userId ?? currentUserId;

    if (profileUserId == null) {
      return const Scaffold(body: Center(child: Text('Not signed in')));
    }

    final isOwnProfile = profileUserId == currentUserId;
    final profileAsync = ref.watch(profileProvider(profileUserId));

    return Scaffold(
      appBar: AppBar(
        title: profileAsync.whenOrNull(
              data: (profile) => Text(
                profile.username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ) ??
            const Text(''),
        actions: [
          if (isOwnProfile) ...[
            IconButton(
              icon: const Icon(Icons.add_box_outlined),
              onPressed: () => context.pushNamed('create_post'),
            ),
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _showSettingsSheet(context),
            ),
          ],
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Failed to load profile: $e')),
        data: (profile) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(profileProvider(profileUserId));
              ref.invalidate(userPostsProvider(profileUserId));
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ProfileAvatar(avatarUrl: profile.avatarUrl, radius: 40),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  StatColumn(count: profile.postCount, label: 'Posts'),
                                  StatColumn(
                                    count: profile.followerCount,
                                    label: 'Followers',
                                    onTap: () {},
                                  ),
                                  StatColumn(
                                    count: profile.followingCount,
                                    label: 'Following',
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (profile.fullName != null && profile.fullName!.isNotEmpty)
                          Text(profile.fullName!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(profile.bio!),
                        ],
                        if (profile.website != null && profile.website!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            profile.website!,
                            style: TextStyle(color: Theme.of(context).colorScheme.primary),
                          ),
                        ],
                        const SizedBox(height: 16),
                        _ActionRow(isOwnProfile: isOwnProfile, targetUserId: profileUserId),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _TabBarDelegate(
                    TabBar(
                      controller: _tabController,
                      labelColor: Theme.of(context).colorScheme.onSurface,
                      indicatorColor: Theme.of(context).colorScheme.onSurface,
                      tabs: const [
                        Tab(icon: Icon(Icons.grid_on)),
                        Tab(icon: Icon(Icons.bookmark_border)),
                      ],
                    ),
                  ),
                ),
                SliverFillRemaining(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _PostsGridTab(userId: profileUserId),
                      if (isOwnProfile)
                        _SavedGridTab(userId: profileUserId)
                      else
                        const Center(
                          child: Text('Saved posts are private', style: TextStyle(color: Colors.grey)),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit Profile'),
              onTap: () {
                Navigator.pop(ctx);
                context.pushNamed('edit_profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(ctx);
                context.pushNamed('settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Log out', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(ctx);
                await ref.read(authControllerProvider.notifier).signOut();
                if (context.mounted) context.go('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionRow extends ConsumerWidget {
  final bool isOwnProfile;
  final String targetUserId;
  const _ActionRow({required this.isOwnProfile, required this.targetUserId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isOwnProfile) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () => context.pushNamed('edit_profile'),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      );
    }

    final currentUserId = ref.watch(currentUserIdProvider);
    final isFollowingAsync = ref.watch(isFollowingProvider(targetUserId));
    final actionsState = ref.watch(profileActionsControllerProvider);

    return isFollowingAsync.when(
      loading: () => const SizedBox(
        height: 36,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (e, st) => const SizedBox.shrink(),
      data: (isFollowing) {
        return Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 36,
                child: ElevatedButton(
                  onPressed: actionsState.isLoading || currentUserId == null
                      ? null
                      : () => ref.read(profileActionsControllerProvider.notifier).toggleFollow(
                            currentUserId: currentUserId,
                            targetUserId: targetUserId,
                            currentlyFollowing: isFollowing,
                          ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFollowing
                        ? Theme.of(context).colorScheme.surfaceContainerHighest
                        : Theme.of(context).colorScheme.primary,
                    foregroundColor: isFollowing
                        ? Theme.of(context).colorScheme.onSurface
                        : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    isFollowing ? 'Following' : 'Follow',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 36,
                child: OutlinedButton(
                  onPressed: () => context.pushNamed('chat_detail', pathParameters: {
                    'conversationId': targetUserId,
                  }),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Message', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PostsGridTab extends ConsumerWidget {
  final String userId;
  const _PostsGridTab({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(userPostsProvider(userId));
    return postsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Failed to load posts: $e')),
      data: (posts) => SingleChildScrollView(
        child: PostGrid(
          posts: posts,
          onTapPost: (index) {},
        ),
      ),
    );
  }
}

class _SavedGridTab extends ConsumerWidget {
  final String userId;
  const _SavedGridTab({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedAsync = ref.watch(savedPostsProvider(userId));
    return savedAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Failed to load saved posts: $e')),
      data: (posts) => SingleChildScrollView(
        child: PostGrid(posts: posts, onTapPost: (index) {}),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
