import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/post_grid.dart';
import '../providers/explore_providers.dart';

class HashtagPostsScreen extends ConsumerWidget {
  final String hashtagId;
  final String hashtagName;

  const HashtagPostsScreen({super.key, required this.hashtagId, required this.hashtagName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(hashtagPostsProvider(hashtagId));

    return Scaffold(
      appBar: AppBar(title: Text('#$hashtagName')),
      body: postsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Failed to load: $e')),
        data: (posts) => SingleChildScrollView(
          child: PostGrid(posts: posts, onTapPost: (index) {}),
        ),
      ),
    );
  }
}
