import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'caption_screen.dart';

class MediaPickerScreen extends StatefulWidget {
  const MediaPickerScreen({super.key});

  @override
  State<MediaPickerScreen> createState() => _MediaPickerScreenState();
}

class _MediaPickerScreenState extends State<MediaPickerScreen> {
  final List<File> _selectedImages = [];
  File? _selectedVideo;
  bool _isPickingVideo = false;
  bool _hasPrompted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasPrompted) {
      _hasPrompted = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _showSourceSheet());
    }
  }

  Future<void> _showSourceSheet() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take Photo'),
              onTap: () => Navigator.pop(ctx, 'camera_photo'),
            ),
            ListTile(
              leading: const Icon(Icons.videocam_outlined),
              title: const Text('Record Video'),
              onTap: () => Navigator.pop(ctx, 'camera_video'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose Photos from Gallery'),
              onTap: () => Navigator.pop(ctx, 'gallery_photos'),
            ),
            ListTile(
              leading: const Icon(Icons.video_library_outlined),
              title: const Text('Choose Video from Gallery'),
              onTap: () => Navigator.pop(ctx, 'gallery_video'),
            ),
          ],
        ),
      ),
    );

    if (choice == null) {
      if (mounted) Navigator.of(context).pop();
      return;
    }

    switch (choice) {
      case 'camera_photo':
        await _pickSinglePhoto(ImageSource.camera);
        break;
      case 'camera_video':
        await _pickVideo(ImageSource.camera);
        break;
      case 'gallery_photos':
        await _pickMultiplePhotos();
        break;
      case 'gallery_video':
        await _pickVideo(ImageSource.gallery);
        break;
    }
  }

  Future<void> _pickSinglePhoto(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 90);
    if (picked == null) {
      if (mounted && _selectedImages.isEmpty && _selectedVideo == null) {
        Navigator.of(context).pop();
      }
      return;
    }
    final cropped = await _cropImage(picked.path);
    if (cropped != null) {
      setState(() => _selectedImages.add(cropped));
    }
  }

  Future<void> _pickMultiplePhotos() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(imageQuality: 90);
    if (picked.isEmpty) {
      if (mounted && _selectedImages.isEmpty && _selectedVideo == null) {
        Navigator.of(context).pop();
      }
      return;
    }
    final limited = picked.take(10).toList();
    setState(() {
      _selectedImages.addAll(limited.map((x) => File(x.path)));
    });
  }

  Future<void> _pickVideo(ImageSource source) async {
    setState(() => _isPickingVideo = true);
    final picker = ImagePicker();
    final picked = await picker.pickVideo(
      source: source,
      maxDuration: const Duration(minutes: 3),
    );
    setState(() => _isPickingVideo = false);

    if (picked == null) {
      if (mounted && _selectedImages.isEmpty) Navigator.of(context).pop();
      return;
    }
    setState(() {
      _selectedVideo = File(picked.path);
      _selectedImages.clear();
    });
  }

  Future<File?> _cropImage(String path) async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          backgroundColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.original,
          ],
        ),
        IOSUiSettings(
          title: 'Crop',
        ),
      ],
    );
    return cropped != null ? File(cropped.path) : null;
  }

  void _removeImage(int index) {
    setState(() => _selectedImages.removeAt(index));
  }

  void _proceed() {
    if (_selectedImages.isEmpty && _selectedVideo == null) return;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CaptionScreen(
        images: List<File>.from(_selectedImages),
        video: _selectedVideo,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final hasMedia = _selectedImages.isNotEmpty || _selectedVideo != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Post'),
        actions: [
          if (hasMedia)
            TextButton(
              onPressed: _proceed,
              child: const Text('Next',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: _isPickingVideo
          ? const Center(child: CircularProgressIndicator())
          : !hasMedia
              ? const Center(child: CircularProgressIndicator())
              : _selectedVideo != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.videocam,
                              size: 64, color: Colors.grey),
                          const SizedBox(height: 8),
                          Text(_selectedVideo!.path.split('/').last),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            itemCount: _selectedImages.length,
                            itemBuilder: (context, index) => Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.file(_selectedImages[index],
                                      fit: BoxFit.contain),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black54,
                                    child: IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.white, size: 18),
                                      onPressed: () => _removeImage(index),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_selectedImages.length > 1)
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                                '${_selectedImages.length} photos selected',
                                style: const TextStyle(color: Colors.grey)),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextButton.icon(
                            onPressed: _pickMultiplePhotos,
                            icon:
                                const Icon(Icons.add_photo_alternate_outlined),
                            label: const Text('Add more photos'),
                          ),
                        ),
                      ],
                    ),
    );
  }
}
