import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/env.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';
import 'certificate_pinning.dart';
import 'session_events.dart';

part 'dio_client.g.dart';

Dio _newDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      contentType: Headers.jsonContentType,
    ),
  );
  // Pinning berlaku untuk Dio utama MAUPUN Dio refresh/retry.
  final pinned = pinnedHttpClientAdapter(parsePins(Env.certSha256Pins));
  if (pinned != null) dio.httpClientAdapter = pinned;
  return dio;
}

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = _newDio();
  final plainDio = _newDio();
  dio.interceptors.addAll([
    AuthInterceptor(
      storage: ref.watch(tokenStorageProvider),
      plainDio: plainDio,
      // Refresh ditolak -> beri tahu AuthController agar router ke /login.
      onSessionExpired: () =>
          ref.read(sessionExpiredProvider.notifier).notify(),
    ),
    if (kDebugMode)
      LogInterceptor(
        requestBody: true,
        responseBody: false,
        logPrint: (o) => debugPrint('$o'),
      ),
  ]);
  ref.onDispose(() {
    dio.close();
    plainDio.close();
  });
  return dio;
}
