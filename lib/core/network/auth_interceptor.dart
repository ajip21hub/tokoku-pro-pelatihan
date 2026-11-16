import 'package:dio/dio.dart';

import '../storage/token_storage.dart';

/// Menyisipkan Bearer token & melakukan refresh otomatis saat 401.
///
/// `QueuedInterceptor` memproses callback SATU PER SATU. Itu saja belum
/// menjamin refresh hanya sekali: jika 5 request gagal 401 bersamaan, kelimanya
/// tetap masuk `onError` berurutan. Karena itu, sebelum refresh kita cek dulu
/// apakah token yang dipakai request ini masih token terbaru. Jika sudah
/// berbeda, berarti request lain di antrean sudah me-refresh -> cukup ulangi.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this.storage,
    required this.plainDio,
    this.onSessionExpired,
  });

  final TokenStorage storage;

  /// Dio TANPA interceptor ini, dipakai untuk refresh & retry.
  /// PENTING: JANGAN retry memakai Dio yang sama: QueuedInterceptor sedang
  /// "mengunci" antrean di onError -> request retry menunggu antrean
  /// yang menunggu dirinya sendiri = DEADLOCK.
  final Dio plainDio;

  /// Dipanggil saat refresh token DITOLAK server (sesi benar-benar habis).
  final void Function()? onSessionExpired;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storage.accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final is401 = err.response?.statusCode == 401;
    final alreadyRetried = err.requestOptions.extra['retried'] == true;
    if (!is401 || alreadyRetried) return handler.next(err);

    // SETIAP jalur keluar wajib memanggil handler. Jika tidak (mis. ada
    // TypeError yang tidak tertangkap), antrean berhenti selamanya -> app hang.
    try {
      var access = await storage.accessToken;
      if (access == null) return handler.next(err); // sudah logout

      final sentWith = err.requestOptions.headers['Authorization'];
      if (sentWith == 'Bearer $access') {
        // Request ini memakai token terbaru -> memang perlu refresh.
        access = await _refresh();
        if (access == null) {
          await storage.clear();
          onSessionExpired?.call();
          return handler.next(err);
        }
      }

      final retryOptions = err.requestOptions
        ..headers['Authorization'] = 'Bearer $access'
        ..extra['retried'] = true;
      final response = await plainDio.fetch<dynamic>(retryOptions);
      return handler.resolve(response);
    } on DioException catch (e) {
      // Gangguan jaringan saat refresh/retry: JANGAN logout user.
      return handler.next(e);
    } catch (e, st) {
      return handler.next(
        DioException(
          requestOptions: err.requestOptions,
          error: e,
          stackTrace: st,
        ),
      );
    }
  }

  /// Mengembalikan access token baru, atau `null` jika server MENOLAK
  /// refresh token (400/401/403). Error jaringan dilempar ulang.
  Future<String?> _refresh() async {
    final refresh = await storage.refreshToken;
    if (refresh == null) return null;
    try {
      final res = await plainDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refresh, 'expiresInMins': 30},
      );
      final data = res.data!;
      final access = data['accessToken'] as String;
      await storage.save(
        access: access,
        refresh: data['refreshToken'] as String,
      );
      return access;
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 400 || code == 401 || code == 403) return null;
      rethrow;
    }
  }
}
