import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/providers.dart';
import '../../../../core/widgets/auth_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/profile_avatar.dart';
import '../providers/profile_providers.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  final _websiteController = TextEditingController();
  bool _initialized = false;
  File? _pickedAvatar;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  void _prefill(profile) {
    if (_initialized) return;
    _fullNameController.text = profile.fullName ?? '';
    _usernameController.text = profile.username;
    _bioController.text = profile.bio ?? '';
    _websiteController.text = profile.website ?? '';
    _initialized = true;
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked != null) {
      setState(() => _pickedAvatar = File(picked.path));
    }
  }

  Future<void> _handleSave(String userId) async {
    final controller = ref.read(profileActionsControllerProvider.notifier);

    if (_pickedAvatar != null) {
      final uploaded = await controller.uploadAvatar(userId: userId, file: _pickedAvatar!);
      if (!uploaded) {
        _showError('Failed to upload avatar');
        return;
      }
    }

    final success = await controller.updateProfile(
      userId: userId,
      fullName: _fullNameController.text.trim(),
      username: _usernameController.text.trim(),
      bio: _bioController.text.trim(),
      website: _websiteController.text.trim(),
    );

    if (success && mounted) {
      context.pop();
    } else if (mounted) {
      _showError('Failed to update profile');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) {
      return const Scaffold(body: Center(child: Text('Not signed in')));
    }

    final profileAsync = ref.watch(profileProvider(userId));
    final actionsState = ref.watch(profileActionsControllerProvider);
    final isSaving = actionsState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: isSaving ? null : () => _handleSave(userId),
            child: isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Failed to load profile: $e')),
        data: (profile) {
          _prefill(profile);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _pickAvatar,
                    child: Stack(
                      children: [
                        _pickedAvatar != null
                            ? CircleAvatar(radius: 48, backgroundImage: FileImage(_pickedAvatar!))
                            : ProfileAvatar(avatarUrl: profile.avatarUrl, radius: 48),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                width: 2,
                              ),
                            ),
                            child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _pickAvatar,
                  child: const Text('Change profile photo'),
                ),
                const SizedBox(height: 16),
                _FieldLabel('Full Name'),
                AuthTextField(controller: _fullNameController, hintText: 'Full Name'),
                const SizedBox(height: 12),
                _FieldLabel('Username'),
                AuthTextField(
                  controller: _usernameController,
                  hintText: 'Username',
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (!RegExp(r'^[a-zA-Z0-9._]{3,30}$').hasMatch(v)) {
                      return 'Letters, numbers, dots, underscores only';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _FieldLabel('Bio'),
                TextField(
                  controller: _bioController,
                  maxLines: 3,
                  maxLength: 150,
                  decoration: InputDecoration(
                    hintText: 'Bio',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
                const SizedBox(height: 12),
                _FieldLabel('Website'),
                AuthTextField(controller: _websiteController, hintText: 'Website'),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: 'Save',
                  isLoading: isSaving,
                  onPressed: () => _handleSave(userId),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
