/// Konfigurasi per-flavor yang ditanam saat compile lewat
/// `--dart-define-from-file=config/<flavor>.json` (lihat Hari 2 & 5).
///
/// PENTING: semua nilai di sini BISA diekstrak dari binary. Jangan pernah menaruh
/// secret server (API secret, password, kredensial DB) di sini.
abstract final class Env {
  static const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://dummyjson.com',
  );

  /// Firebase (FCM, Crashlytics, Remote Config, AI Logic) baru aktif di Hari 5.
  static const enableFirebase = bool.fromEnvironment('ENABLE_FIREBASE');

  /// Server WebSocket status pesanan (Hari 3). 10.0.2.2 = localhost dari
  /// emulator Android.
  static const wsBaseUrl = String.fromEnvironment(
    'WS_BASE_URL',
    defaultValue: 'ws://10.0.2.2:8080',
  );

  /// SHA-256 sertifikat yang dipercaya (pisahkan dengan koma). Kosong =
  /// certificate pinning nonaktif (Hari 2).
  static const certSha256Pins = String.fromEnvironment('CERT_SHA256_PINS');

  static bool get isDev => flavor == 'dev';
}
