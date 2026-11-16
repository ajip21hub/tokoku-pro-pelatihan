// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Versi Hari 1: Dio dasar untuk katalog dummyjson.
///
/// Pada Hari 2 (Sesi 1–3) file ini diganti dengan versi produksi: base URL
/// dari `Env` (`--dart-define-from-file`), `AuthInterceptor`, dan
/// certificate pinning.

@ProviderFor(dio)
final dioProvider = DioProvider._();

/// Versi Hari 1: Dio dasar untuk katalog dummyjson.
///
/// Pada Hari 2 (Sesi 1–3) file ini diganti dengan versi produksi: base URL
/// dari `Env` (`--dart-define-from-file`), `AuthInterceptor`, dan
/// certificate pinning.

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Versi Hari 1: Dio dasar untuk katalog dummyjson.
  ///
  /// Pada Hari 2 (Sesi 1–3) file ini diganti dengan versi produksi: base URL
  /// dari `Env` (`--dart-define-from-file`), `AuthInterceptor`, dan
  /// certificate pinning.
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'03245015c70126c684fb3f2decf68945ec0cd09d';
