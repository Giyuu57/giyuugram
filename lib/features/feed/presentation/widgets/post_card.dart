import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:go_router/go_router.dart';
import '../../../../shared_models/post.dart';
import '../../../../core/widgets/profile_avatar.dart';
import '../providers/feed_providers.dart';
import 'comments_sheet.dart';

class PostCard extends ConsumerStatefulWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> with SingleTickerProviderStateMixin {
  late AnimationController _heartAnimController;
  bool _showHeartOverlay = false;
  int _currentCarouselIndex = 0;
  final PageController _carouselController = PageController();

  @override
  void initState() {
    super.initState();
    _heartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _heartAnimController.dispose();
    _carouselController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    if (!widget.post.isLikedByMe) {
      ref.read(feedControllerProvider.notifier).toggleLike(widget.post.id);
    }
    setState(() => _showHeartOverlay = true);
    _heartAnimController.forward(from: 0).then((_) {
      if (mounted) setState(() => _showHeartOverlay = false);
    });
  }

  void _openComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CommentsSheet(post: widget.post),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              ProfileAvatar(
                avatarUrl: post.authorAvatarUrl,
                radius: 16,
                onTap: () => context.pushNamed('user_profile', pathParameters: {'userId': post.userId}),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => context.pushNamed('user_profile', pathParameters: {'userId': post.userId}),
                  child: Text(
                    post.authorUsername ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
        ),
        GestureDetector(
          onDoubleTap: _handleDoubleTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: post.mediaUrls.length > 1
                    ? Stack(
                        children: [
                          PageView.builder(
                            controller: _carouselController,
                            itemCount: post.mediaUrls.length,
                            onPageChanged: (i) => setState(() => _currentCarouselIndex = i),
                            itemBuilder: (context, i) => CachedNetworkImage(
                              imageUrl: post.mediaUrls[i],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(color: Colors.grey.shade900),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${_currentCarouselIndex + 1}/${post.mediaUrls.length}',
                                style: const TextStyle(color: Colors.white, fontSize: 11),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            child: Row(
                              children: List.generate(post.mediaUrls.length, (i) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: i == _currentCarouselIndex
                                        ? Colors.white
                                        : Colors.white38,
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      )
                    : CachedNetworkImage(
                        imageUrl: post.mediaUrls.first,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: Colors.grey.shade900),
                      ),
              ),
              AnimatedOpacity(
                opacity: _showHeartOverlay ? 1 : 0,
                duration: const Duration(milliseconds: 150),
                child: const Icon(Icons.favorite, color: Colors.white, size: 100, shadows: [
                  Shadow(blurRadius: 12, color: Colors.black38),
                ]),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  post.isLikedByMe ? Icons.favorite : Icons.favorite_border,
                  color: post.isLikedByMe ? Colors.red : null,
                ),
                onPressed: () => ref.read(feedControllerProvider.notifier).toggleLike(post.id),
              ),
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                onPressed: _openComments,
              ),
              IconButton(
                icon: const Icon(Icons.send_outlined),
                onPressed: () {},
              ),
              const Spacer(),
              IconButton(
                icon: Icon(post.isSavedByMe ? Icons.bookmark : Icons.bookmark_border),
                onPressed: () => ref.read(feedControllerProvider.notifier).toggleSave(post.id),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (post.likeCount > 0)
                Text('${post.likeCount} likes', style: const TextStyle(fontWeight: FontWeight.bold)),
              if (post.caption != null && post.caption!.isNotEmpty) ...[
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(
                        text: '${post.authorUsername} ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: post.caption),
                    ],
                  ),
                ),
              ],
              if (post.commentCount > 0) ...[
                const SizedBox(height: 2),
                GestureDetector(
                  onTap: _openComments,
                  child: Text(
                    'View all ${post.commentCount} comments',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                timeago.format(post.createdAt),
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
