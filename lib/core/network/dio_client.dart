import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

/// Versi Hari 1: Dio dasar untuk katalog dummyjson.
///
/// Pada Hari 2 (Sesi 1–3) file ini diganti dengan versi produksi: base URL
/// dari `Env` (`--dart-define-from-file`), `AuthInterceptor`, dan
/// certificate pinning.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
  ref.onDispose(dio.close);
  return dio;
}
