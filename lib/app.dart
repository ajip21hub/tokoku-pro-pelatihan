import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/settings/theme_mode_controller.dart';
import 'features/products/presentation/product_list_page.dart';
import 'l10n/app_localizations.dart';

/// Versi Hari 1: katalog langsung menjadi halaman awal. Tombol cari dan
/// detail produk baru berfungsi setelah router dipasang pada Lab 2B.
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
      home: const ProductListPage(),
    );
  }
}
