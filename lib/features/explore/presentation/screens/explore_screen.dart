import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/post_grid.dart';
import '../../../../core/widgets/profile_avatar.dart';
import '../providers/explore_providers.dart';
import 'hashtag_posts_screen.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    ref.read(searchQueryProvider.notifier).state = value;
    setState(() => _isSearching = value.trim().isNotEmpty);
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(searchQueryProvider.notifier).state = '';
    setState(() => _isSearching = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search',
            prefixIcon: const Icon(Icons.search, size: 20),
            suffixIcon: _isSearching
                ? IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: _clearSearch,
                  )
                : null,
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF262626)
                : const Color(0xFFEFEFEF),
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      body: _isSearching ? const _SearchResultsView() : const _ExploreGridView(),
    );
  }
}

class _ExploreGridView extends ConsumerWidget {
  const _ExploreGridView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(explorePostsProvider);

    return postsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Failed to load: $e')),
      data: (posts) {
        if (posts.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'No trending posts yet.\nCheck back soon!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(explorePostsProvider),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: PostGrid(posts: posts, onTapPost: (index) {}),
          ),
        );
      },
    );
  }
}

class _SearchResultsView extends ConsumerWidget {
  const _SearchResultsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(userSearchResultsProvider);
    final hashtagsAsync = ref.watch(hashtagSearchResultsProvider);

    return ListView(
      children: [
        hashtagsAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (e, st) => const SizedBox.shrink(),
          data: (hashtags) {
            if (hashtags.isEmpty) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Text('Tags', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                ),
                ...hashtags.map((tag) => ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.tag)),
                      title: Text('#${tag['tag']}'),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => HashtagPostsScreen(
                            hashtagId: tag['id'] as String,
                            hashtagName: tag['tag'] as String,
                          ),
                        ));
                      },
                    )),
                const Divider(),
              ],
            );
          },
        ),
        usersAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, st) => Center(child: Text('Failed to search: $e')),
          data: (users) {
            if (users.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: Text('No results found', style: TextStyle(color: Colors.grey))),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Text('Accounts', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                ),
                ...users.map((user) => ListTile(
                      leading: ProfileAvatar(avatarUrl: user['avatar_url'], radius: 20),
                      title: Text(user['username'] ?? ''),
                      subtitle: user['full_name'] != null ? Text(user['full_name']) : null,
                      onTap: () => context.pushNamed(
                        'user_profile',
                        pathParameters: {'userId': user['id'] as String},
                      ),
                    )),
              ],
            );
          },
        ),
      ],
    );
  }
}
