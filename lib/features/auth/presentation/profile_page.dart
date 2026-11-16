import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/settings/theme_mode_controller.dart';

/// Halaman Profil dari starter; dipasang sebagai tab ketiga di Lab 2B.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode themeMode =
        ref.watch(themeModeControllerProvider).value ?? .system;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        children: [
          // TODO(Lab 2A): tampilkan nama dan email dari authControllerProvider.
          // TODO(Lab 4E): tampilkan info perangkat dari deviceInfoProvider.
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
          // TODO(Lab 4C): pemilih bahasa ID/EN (LanguageController).
          // TODO(Lab 2A): tombol Keluar -> authControllerProvider.notifier.logout().
        ],
      ),
    );
  }
}
