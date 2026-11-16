import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'features/cart/data/background_sync.dart';

/// Versi Hari 3–4. Firebase (Crashlytics, FCM, App Check) ditambahkan
/// pada Hari 5; lihat `main.dart` di materi Hari 5.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Sinkronisasi keranjang periodik walau app ditutup (Hari 3).
  if (defaultTargetPlatform == TargetPlatform.android) {
    await registerBackgroundSync();
  }

  runApp(const ProviderScope(child: TokoKuApp()));
}
