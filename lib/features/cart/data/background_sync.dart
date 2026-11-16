import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';

import 'cart_sync_service.dart';

const cartSyncTask = 'tokoku.cartSync';

/// Titik masuk isolate background. WAJIB top-level + `vm:entry-point`
/// (kalau tidak, tree-shaking release build membuangnya).
///
/// Isolate ini TIDAK berbagi memori dengan UI: tidak ada ProviderScope,
/// tidak ada state Riverpod dari app. Kita buat ProviderContainer sendiri ->
/// provider yang sama (DB, Dio, CartSyncService) dipakai ulang tanpa duplikasi.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task != cartSyncTask) return true;
    final container = ProviderContainer();
    try {
      final synced = await container.read(cartSyncServiceProvider).syncNow();
      debugPrint('[bg] $synced item keranjang tersinkron');
      return true;
    } catch (e) {
      debugPrint('[bg] sync gagal: $e');
      return false; // WorkManager akan menjadwalkan ulang (backoff)
    } finally {
      container.dispose();
    }
  });
}

/// Android membatasi tugas periodik minimal 15 menit & menjalankannya saat
/// sistem mengizinkan (Doze, hemat baterai) -> "kurang lebih tiap 15 menit".
Future<void> registerBackgroundSync() async {
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    cartSyncTask,
    cartSyncTask,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );
}
