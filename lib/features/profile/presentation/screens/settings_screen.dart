import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../auth/presentation/providers/auth_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text('Appearance', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('System default'),
            value: ThemeMode.system,
            groupValue: themeMode,
            onChanged: (v) => ref.read(themeModeProvider.notifier).state = v!,
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Light'),
            value: ThemeMode.light,
            groupValue: themeMode,
            onChanged: (v) => ref.read(themeModeProvider.notifier).state = v!,
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Dark'),
            value: ThemeMode.dark,
            groupValue: themeMode,
            onChanged: (v) => ref.read(themeModeProvider.notifier).state = v!,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Log out', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await ref.read(authControllerProvider.notifier).signOut();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}
