import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostGrid extends StatelessWidget {
  final List<Map<String, dynamic>> posts;
  final void Function(int index)? onTapPost;

  const PostGrid({super.key, required this.posts, this.onTapPost});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 80),
        child: Center(
          child: Text('No posts yet', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        final mediaUrls = List<String>.from(post['media_urls'] ?? []);
        final thumbnail = post['thumbnail_url'] ?? (mediaUrls.isNotEmpty ? mediaUrls.first : null);
        final isCarousel = mediaUrls.length > 1;
        final isVideo = post['type'] == 'video' || post['type'] == 'reel';

        return GestureDetector(
          onTap: () => onTapPost?.call(index),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (thumbnail != null)
                CachedNetworkImage(
                  imageUrl: thumbnail,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Colors.grey.shade900),
                  errorWidget: (context, url, error) => Container(color: Colors.grey.shade800),
                )
              else
                Container(color: Colors.grey.shade900),
              if (isCarousel)
                const Positioned(
                  top: 6,
                  right: 6,
                  child: Icon(Icons.collections, color: Colors.white, size: 18),
                ),
              if (isVideo)
                const Positioned(
                  top: 6,
                  right: 6,
                  child: Icon(Icons.play_arrow, color: Colors.white, size: 20),
                ),
            ],
          ),
        );
      },
    );
  }
}
