import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'env.dart';

part 'feature_flags.g.dart';

/// Feature flag dari Firebase Remote Config: fitur bisa dinyalakan/dimatikan
/// (atau di-rollout 10% user) TANPA rilis ulang ke Play Store.
class const FeatureFlags(final bool aiSummaryEnabled, final String aiModel) {
  /// Nilai default = nilai saat Firebase nonaktif / fetch gagal.
  /// Default fitur baru selalu MATI -> aman jika konfigurasi tidak terbaca.
  static const defaults = FeatureFlags(false, 'gemini-3.8-flash');
}

@Riverpod(keepAlive: true)
Future<FeatureFlags> featureFlags(Ref ref) async {
  if (!Env.enableFirebase) return FeatureFlags.defaults;

  final rc = FirebaseRemoteConfig.instance;
  await rc.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      // Produksi: jangan fetch terlalu sering (ada kuota). Debug: selalu baru.
      minimumFetchInterval: kDebugMode
          ? Duration.zero
          : const Duration(hours: 1),
    ),
  );
  await rc.setDefaults({
    'ai_summary_enabled': FeatureFlags.defaults.aiSummaryEnabled,
    'ai_model': FeatureFlags.defaults.aiModel,
  });
  try {
    await rc.fetchAndActivate();
  } catch (e) {
    debugPrint('Remote Config gagal, pakai nilai tersimpan/default: $e');
  }
  return FeatureFlags(
    rc.getBool('ai_summary_enabled'),
    rc.getString('ai_model'),
  );
}
