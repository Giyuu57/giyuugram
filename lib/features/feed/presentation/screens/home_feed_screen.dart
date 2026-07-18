import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/post_card_skeleton.dart';
import '../../../../core/widgets/stories_row_skeleton.dart';
import '../../../stories/presentation/widgets/stories_row.dart';
import '../providers/feed_providers.dart';
import '../widgets/post_card.dart';

class HomeFeedScreen extends ConsumerStatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  ConsumerState<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends ConsumerState<HomeFeedScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 800) {
      ref.read(feedControllerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(feedControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Giyuugram',
          style: TextStyle(fontFamily: 'Billabong', fontSize: 28),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () => context.pushNamed('activity'),
          ),
          IconButton(
            icon: const Icon(Icons.send_outlined),
            onPressed: () => context.pushNamed('chat_list'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(feedControllerProvider.notifier).refresh(),
        child: feedState.posts.isEmpty && feedState.isLoadingMore
            ? ListView(
                children: const [
                  StoriesRowSkeleton(),
                  PostCardSkeleton(),
                  PostCardSkeleton(),
                ],
              )
            : feedState.posts.isEmpty
                ? ListView(
                    children: [
                      const StoriesRow(),
                      const Divider(height: 1),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text(
                              'No posts yet.\nFollow people to see their posts here!',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: feedState.posts.length + 2, // +stories row +loader
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return const Column(
                          children: [StoriesRow(), Divider(height: 1)],
                        );
                      }
                      final postIndex = index - 1;
                      if (postIndex < feedState.posts.length) {
                        return PostCard(post: feedState.posts[postIndex]);
                      }
                      // Bottom loader
                      if (feedState.isLoadingMore) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
      ),
    );
  }
}