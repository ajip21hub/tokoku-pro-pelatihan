import 'package:dio/dio.dart';

/// Hierarki error domain. `sealed` memaksa UI menangani semua kasus
/// lewat `switch` yang exhaustive.
sealed class Failure implements Exception {
  const Failure(this.message);
  final String message;

  @override
  String toString() => message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Tidak ada koneksi internet']);
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    super.message = 'Sesi berakhir, silakan login lagi',
  ]);
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode});
  final int? statusCode;
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Terjadi kesalahan tak terduga']);
}

/// Mengubah DioException menjadi Failure yang ramah domain.
Failure mapDioError(Object error) {
  if (error is Failure) return error;
  if (error is! DioException) return const UnknownFailure();
  return switch (error.type) {
    DioExceptionType.connectionError ||
    DioExceptionType.connectionTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.sendTimeout => const NetworkFailure(),
    DioExceptionType.badResponse when error.response?.statusCode == 401 =>
      const UnauthorizedFailure(),
    DioExceptionType.badResponse => ServerFailure(
      (error.response?.data is Map
              ? (error.response!.data as Map)['message']?.toString()
              : null) ??
          'Server error',
      statusCode: error.response?.statusCode,
    ),
    _ => const UnknownFailure(),
  };
}
