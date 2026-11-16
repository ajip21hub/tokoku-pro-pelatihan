import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

import '../../firebase_options.dart';

/// Handler pesan saat app di background/terminated.
/// HARUS fungsi top-level + anotasi entry-point.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('BG message: ${message.messageId}');
}

class PushService {
  PushService(this._router);
  final GoRouter _router;

  final _local = FlutterLocalNotificationsPlugin();
  static const _channel = AndroidNotificationChannel(
    'promo_channel',
    'Promo & Pesanan',
    description: 'Notifikasi promo dan status pesanan',
    importance: Importance.high,
  );

  Future<void> init() async {
    final messaging = FirebaseMessaging.instance;

    // 1. Izin (Android 13+ & iOS wajib minta izin runtime)
    final settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.denied) return;

    // 2. Local notification untuk menampilkan pesan saat app foreground
    await _local.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (r) => _openDeepLink(r.payload),
    );
    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // 3. Registrasi FCM (API baru firebase_messaging 17+).
    //    onRegistered memberi Firebase Installation ID (FID) sebagai target
    //    kirim -> simpan ke backend Anda. (getToken() kini deprecated.)
    messaging.onRegistered.listen((fid) => debugPrint('FCM FID: $fid'));
    await messaging.register();

    // 4. Pesan saat app di foreground
    FirebaseMessaging.onMessage.listen((m) {
      final n = m.notification;
      if (n == null) return;
      _local.show(
        id: n.hashCode,
        title: n.title,
        body: n.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        payload: m.data['route'] as String?,
      );
    });

    // 5. User tap notifikasi saat app background
    FirebaseMessaging.onMessageOpenedApp.listen(
      (m) => _openDeepLink(m.data['route'] as String?),
    );

    // 6. App dibuka dari kondisi terminated lewat notifikasi.
    //    `go` (bukan push): belum ada stack. Jika status login belum
    //    diketahui, redirect menyimpan rute ini di ?from= lalu melanjutkannya.
    final initial = await messaging.getInitialMessage();
    _openDeepLink(initial?.data['route'] as String?, replace: true);
  }

  /// Payload `route` contoh: "/products/12". Hanya rute internal ('/...')
  /// yang diterima -> payload notifikasi tidak bisa membuka URL sembarangan.
  void _openDeepLink(String? route, {bool replace = false}) {
    if (route == null || !route.startsWith('/') || route.startsWith('//')) {
      return;
    }
    replace ? _router.go(route) : _router.push(route);
  }
}
