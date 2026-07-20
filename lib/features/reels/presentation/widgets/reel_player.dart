import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/profile_avatar.dart';
import '../../../feed/presentation/providers/feed_providers.dart';
import '../../../feed/presentation/widgets/comments_sheet.dart';
import '../../../../shared_models/post.dart';
import '../providers/reels_providers.dart';

class ReelPlayer extends ConsumerStatefulWidget {
  final Map<String, dynamic> reel;
  final bool isMuted;
  final VoidCallback onToggleMute;

  const ReelPlayer({
    super.key,
    required this.reel,
    required this.isMuted,
    required this.onToggleMute,
  });

  @override
  ConsumerState<ReelPlayer> createState() => _ReelPlayerState();
}

class _ReelPlayerState extends ConsumerState<ReelPlayer> {
  VideoPlayerController? _controller;
  bool _isVisible = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final mediaUrls = List<String>.from(widget.reel['media_urls'] ?? []);
    if (mediaUrls.isEmpty) return;

    final controller = VideoPlayerController.networkUrl(Uri.parse(mediaUrls.first));
    await controller.initialize();
    controller.setLooping(true);
    controller.setVolume(widget.isMuted ? 0 : 1);

    if (!mounted) {
      controller.dispose();
      return;
    }
    setState(() {
      _controller = controller;
      _isInitialized = true;
    });
    if (_isVisible) controller.play();
  }

  @override
  void didUpdateWidget(covariant ReelPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isMuted != widget.isMuted) {
      _controller?.setVolume(widget.isMuted ? 0 : 1);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    final isNowVisible = info.visibleFraction > 0.7;
    if (isNowVisible == _isVisible) return;
    _isVisible = isNowVisible;

    if (_controller == null || !_isInitialized) return;
    if (_isVisible) {
      _controller!.play();
    } else {
      _controller!.pause();
    }
  }

  void _openComments() {
    final post = Post.fromJson({
      'id': widget.reel['id'],
      'userId': widget.reel['user_id'],
      'caption': widget.reel['caption'],
      'mediaUrls': List<String>.from(widget.reel['media_urls'] ?? []),
      'thumbnailUrl': widget.reel['thumbnail_url'],
      'type': widget.reel['type'],
      'likeCount': widget.reel['like_count'],
      'commentCount': widget.reel['comment_count'],
      'createdAt': widget.reel['created_at'],
      'authorUsername': widget.reel['author_username'],
      'authorAvatarUrl': widget.reel['author_avatar_url'],
    });
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CommentsSheet(post: post),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reel = widget.reel;
    final isLiked = reel['is_liked_by_me'] as bool? ?? false;
    final isSaved = reel['is_saved_by_me'] as bool? ?? false;
    final likeCount = reel['like_count'] as int? ?? 0;
    final commentCount = reel['comment_count'] as int? ?? 0;

    return VisibilityDetector(
      key: Key('reel-${reel['id']}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: GestureDetector(
        onTap: widget.onToggleMute,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_isInitialized && _controller != null)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller!.value.size.width,
                  height: _controller!.value.size.height,
                  child: VideoPlayer(_controller!),
                ),
              )
            else if (reel['thumbnail_url'] != null)
              CachedNetworkImage(imageUrl: reel['thumbnail_url'], fit: BoxFit.cover)
            else
              Container(color: Colors.black),

            if (!_isInitialized)
              const Center(child: CircularProgressIndicator(color: Colors.white)),

            if (_isInitialized)
              Positioned(
                top: 16,
                right: 16,
                child: Icon(
                  widget.isMuted ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white70,
                ),
              ),

            Positioned(
              left: 0,
              right: 80,
              bottom: 24,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => context.pushNamed('user_profile',
                          pathParameters: {'userId': reel['user_id'] as String}),
                      child: Row(
                        children: [
                          ProfileAvatar(avatarUrl: reel['author_avatar_url'], radius: 16),
                          const SizedBox(width: 8),
                          Text(
                            reel['author_username'] ?? '',
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    if (reel['caption'] != null && (reel['caption'] as String).isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        reel['caption'] as String,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            Positioned(
              right: 8,
              bottom: 24,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.white,
                      size: 30,
                    ),
                    onPressed: () => ref
                        .read(reelsControllerProvider.notifier)
                        .toggleLike(reel['id'] as String, ref.read(feedRepositoryProvider)),
                  ),
                  Text('$likeCount', style: const TextStyle(color: Colors.white, fontSize: 12)),
                  const SizedBox(height: 16),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 28),
                    onPressed: _openComments,
                  ),
                  Text('$commentCount', style: const TextStyle(color: Colors.white, fontSize: 12)),
                  const SizedBox(height: 16),
                  IconButton(
                    icon: const Icon(Icons.send_outlined, color: Colors.white, size: 26),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 16),
                  IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.white,
                      size: 26,
                    ),
                    onPressed: () => ref
                        .read(reelsControllerProvider.notifier)
                        .toggleSave(reel['id'] as String, ref.read(feedRepositoryProvider)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
