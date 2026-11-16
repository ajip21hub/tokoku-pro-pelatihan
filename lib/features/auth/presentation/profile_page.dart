import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/settings/theme_mode_controller.dart';
import 'auth_controller.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    final ThemeMode themeMode =
        ref.watch(themeModeControllerProvider).value ?? .system;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(
              user == null ? '-' : '${user.firstName} ${user.lastName}',
            ),
            subtitle: Text(user?.email ?? ''),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: .light, label: Text('Terang')),
                ButtonSegment(value: .system, label: Text('Sistem')),
                ButtonSegment(value: .dark, label: Text('Gelap')),
              ],
              selected: {themeMode},
              onSelectionChanged: (s) =>
                  ref.read(themeModeControllerProvider.notifier).set(s.single),
            ),
          ),
          // Lab 4C: pemilih bahasa. Lab 4E: info perangkat dari Kotlin.
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Keluar'),
            onTap: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
    );
  }
}
