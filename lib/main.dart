import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/env.dart';
import 'features/cart/data/background_sync.dart';
import 'features/notifications/push_service.dart';
import 'firebase_options.dart';
import 'router/app_router.dart';

/// Firebase diaktifkan lewat ENABLE_FIREBASE di `config/<flavor>.json`
/// agar Hari 1–4 tetap bisa jalan tanpa konfigurasi Firebase.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();

  if (Env.enableFirebase) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // App Check: hanya app asli (Play Integrity) yang boleh memakai
    // backend Firebase, termasuk Gemini via AI Logic.
    await FirebaseAppCheck.instance.activate(
      providerAndroid: kDebugMode
          ? const AndroidDebugProvider()
          : const AndroidPlayIntegrityProvider(),
    );
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Crashlytics: tangkap error Flutter & error async yang tidak tertangani
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  // Sinkronisasi keranjang periodik walau app ditutup (Hari 3).
  if (defaultTargetPlatform == TargetPlatform.android) {
    await registerBackgroundSync();
  }

  runApp(
    UncontrolledProviderScope(container: container, child: const TokoKuApp()),
  );

  // Setelah frame pertama: dialog izin notifikasi tidak menahan tampilan awal.
  if (Env.enableFirebase) {
    await PushService(container.read(appRouterProvider)).init();
  }
}
