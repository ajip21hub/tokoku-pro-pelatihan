import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/settings/theme_mode_controller.dart';
import 'features/auth/presentation/login_page.dart';
import 'l10n/app_localizations.dart';

class TokoKuApp extends ConsumerWidget {
  const TokoKuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeControllerProvider).value;
    return MaterialApp(
      title: 'TokoKu Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      darkTheme: ThemeData(colorSchemeSeed: Colors.indigo, brightness: .dark),
      themeMode: themeMode ?? .system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // Lab Capstone 1 (Hari 1): ganti dengan `const ProductListPage()`.
      // Lab 2B (Hari 2): ganti MaterialApp dengan MaterialApp.router
      // (lihat `app.dart` di materi Hari 2).
      home: const LoginPage(),
    );
  }
}
