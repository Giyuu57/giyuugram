import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/providers.dart';
import '../../../feed/presentation/providers/create_post_provider.dart';
import '../../../feed/presentation/providers/feed_providers.dart';

class CaptionScreen extends ConsumerStatefulWidget {
  final List<File> images;
  final File? video;

  const CaptionScreen({super.key, required this.images, this.video});

  @override
  ConsumerState<CaptionScreen> createState() => _CaptionScreenState();
}

class _CaptionScreenState extends ConsumerState<CaptionScreen> {
  final _captionController = TextEditingController();
  final _locationController = TextEditingController();
  bool _postAsReel = false;

  @override
  void initState() {
    super.initState();
    // Default videos to Reel, matching modern Instagram behavior where
    // vertical video primarily goes to Reels.
    _postAsReel = widget.video != null;
  }

  @override
  void dispose() {
    _captionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _handleShare() async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    final isVideo = widget.video != null;
    String? thumbnailPath;

    if (isVideo) {
      thumbnailPath =
          await ref.read(feedRepositoryProvider).generateVideoThumbnail(widget.video!.path);
    }

    final success = await ref.read(createPostControllerProvider.notifier).submit(
          userId: userId,
          mediaFiles: isVideo ? [widget.video!] : widget.images,
          caption: _captionController.text.trim().isEmpty ? null : _captionController.text.trim(),
          location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
          type: isVideo ? (_postAsReel ? 'reel' : 'video') : 'image',
          thumbnailFile: thumbnailPath,
        );

    if (success && mounted) {
      context.go(_postAsReel ? '/reels' : '/home');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_postAsReel ? 'Reel shared successfully!' : 'Post shared successfully!')),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to share post. Please try again.'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(createPostControllerProvider);
    final isUploading = uploadState.isLoading;
    final previewFile = widget.video ?? widget.images.first;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video != null ? 'New Reel / Video' : 'New Post'),
        actions: [
          TextButton(
            onPressed: isUploading ? null : _handleShare,
            child: isUploading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Share', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: widget.video != null
                        ? Container(
                            width: 64,
                            height: 64,
                            color: Colors.black,
                            child: const Icon(Icons.videocam, color: Colors.white),
                          )
                        : Image.file(previewFile, width: 64, height: 64, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _captionController,
                      maxLines: 4,
                      minLines: 1,
                      decoration: const InputDecoration(
                        hintText: 'Write a caption... use #hashtags',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            if (widget.video != null)
              SwitchListTile(
                title: const Text('Post to Reels'),
                subtitle: const Text('Vertical videos are recommended for Reels'),
                value: _postAsReel,
                onChanged: (v) => setState(() => _postAsReel = v),
              ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  hintText: 'Add location',
                  border: InputBorder.none,
                ),
              ),
            ),
            const Divider(height: 1),
          ],
        ),
      ),
    );
  }
}
