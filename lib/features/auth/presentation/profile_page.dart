import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/platform/device_info_provider.dart';
import '../../../core/settings/theme_mode_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../../warmup/language_controller.dart';
import 'auth_controller.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    final ThemeMode themeMode =
        ref.watch(themeModeControllerProvider).value ?? .system;
    final device = ref.watch(deviceInfoProvider).value;
    final locale = ref.watch(currentLocaleProvider);

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
          // Data dari kode native Kotlin lewat Pigeon (Hari 4).
          if (device != null)
            ListTile(
              leading: const Icon(Icons.phone_android),
              title: Text(device.model),
              subtitle: Text(
                'Android ${device.osVersion} • baterai ${device.batteryLevel}%',
              ),
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
          ListTile(
            title: Text(AppLocalizations.of(context).languageLabel),
            trailing: SegmentedButton<Locale>(
              segments: const [
                ButtonSegment(value: Locale('id'), label: Text('ID')),
                ButtonSegment(value: Locale('en'), label: Text('EN')),
              ],
              selected: {locale},
              onSelectionChanged: (s) => ref
                  .read(languageControllerProvider.notifier)
                  .change(s.single),
            ),
          ),
          // Tombol uji Crashlytics: hanya build dev yang mengaktifkan Firebase.
          if (Env.isDev && Env.enableFirebase)
            ListTile(
              leading: const Icon(Icons.bug_report),
              title: const Text('Test crash (dev)'),
              onTap: () => FirebaseCrashlytics.instance.crash(),
            ),
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
