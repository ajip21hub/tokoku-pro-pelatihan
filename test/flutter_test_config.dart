import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';
import 'package:leak_tracker_flutter_testing/leak_tracker_flutter_testing.dart';

/// Dijalankan otomatis oleh `flutter test` sebelum SETIAP file test di folder
/// ini (nama file wajib `flutter_test_config.dart`).
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // 1) Leak tracking global: widget test gagal jika ada objek Disposable
  //    (TextEditingController, AnimationController, ...) yang tidak di-dispose.
  LeakTesting.enable();
  LeakTesting.settings = LeakTesting.settings.withIgnored(
    // Objek internal paket pihak ketiga di luar kendali kita.
    createdByTestHelpers: true,
  );

  // 2) alchemist: CI golden (teks berupa kotak, identik di semua OS) selalu
  //    dibuat; platform golden (font asli) hanya di mesin developer.
  final isCi = Platform.environment.containsKey('CI');
  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      platformGoldensConfig: PlatformGoldensConfig(enabled: !isCi),
    ),
    run: testMain,
  );
}
