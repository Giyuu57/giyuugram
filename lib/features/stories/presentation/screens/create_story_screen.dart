import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/providers.dart';
import '../providers/story_upload_provider.dart';

class CreateStoryScreen extends ConsumerStatefulWidget {
  const CreateStoryScreen({super.key});

  @override
  ConsumerState<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends ConsumerState<CreateStoryScreen> {
  File? _selectedFile;
  final String _mediaType = 'image';
  bool _hasPromptedPicker = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasPromptedPicker) {
      _hasPromptedPicker = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _showSourceSheet());
    }
  }

  Future<void> _showSourceSheet() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take Photo'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) {
      if (mounted) Navigator.of(context).pop();
      return;
    }

    await _pickImage(source);
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 85);

    if (picked == null) {
      if (mounted) Navigator.of(context).pop();
      return;
    }

    setState(() {
      _selectedFile = File(picked.path);
    });
  }

  Future<void> _handlePost() async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null || _selectedFile == null) return;

    final success = await ref.read(storyUploadControllerProvider.notifier).uploadStory(
          userId: userId,
          file: _selectedFile!,
          mediaType: _mediaType,
        );

    if (success && mounted) {
      Navigator.of(context).pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload story. Please try again.'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(storyUploadControllerProvider);
    final isUploading = uploadState.isLoading;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('New Story', style: TextStyle(color: Colors.white)),
        actions: [
          if (_selectedFile != null)
            TextButton(
              onPressed: isUploading ? null : _handlePost,
              child: isUploading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Share', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: _selectedFile == null
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : Center(
              child: Image.file(_selectedFile!, fit: BoxFit.contain),
            ),
    );
  }
}
