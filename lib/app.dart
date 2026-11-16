import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/settings/theme_mode_controller.dart';
import 'l10n/app_localizations.dart';
import 'router/app_router.dart';
import 'warmup/language_controller.dart';

class TokoKuApp extends ConsumerWidget {
  const TokoKuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeControllerProvider).value;
    return MaterialApp.router(
      title: 'TokoKu Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      darkTheme: ThemeData(colorSchemeSeed: Colors.indigo, brightness: .dark),
      themeMode: themeMode ?? .system,
      // Lokalisasi (Hari 4): bahasa dipilih di halaman Profil dan disimpan
      // oleh LanguageController hasil migrasi Hari 1.
      locale: ref.watch(currentLocaleProvider),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
