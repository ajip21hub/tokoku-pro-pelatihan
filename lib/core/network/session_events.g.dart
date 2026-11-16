// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_events.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// "Bel" sesi berakhir. Dio (lapisan core) membunyikannya, AuthController
/// (fitur auth) mendengarkannya. Dengan begitu `core/` tidak perlu meng-import
/// fitur auth -> tidak ada dependensi melingkar.

@ProviderFor(SessionExpired)
final sessionExpiredProvider = SessionExpiredProvider._();

/// "Bel" sesi berakhir. Dio (lapisan core) membunyikannya, AuthController
/// (fitur auth) mendengarkannya. Dengan begitu `core/` tidak perlu meng-import
/// fitur auth -> tidak ada dependensi melingkar.
final class SessionExpiredProvider
    extends $NotifierProvider<SessionExpired, int> {
  /// "Bel" sesi berakhir. Dio (lapisan core) membunyikannya, AuthController
  /// (fitur auth) mendengarkannya. Dengan begitu `core/` tidak perlu meng-import
  /// fitur auth -> tidak ada dependensi melingkar.
  SessionExpiredProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionExpiredProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionExpiredHash();

  @$internal
  @override
  SessionExpired create() => SessionExpired();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$sessionExpiredHash() => r'74a62641ecae93c2e5648a0cfde9dbf6c95356e7';

/// "Bel" sesi berakhir. Dio (lapisan core) membunyikannya, AuthController
/// (fitur auth) mendengarkannya. Dengan begitu `core/` tidak perlu meng-import
/// fitur auth -> tidak ada dependensi melingkar.

abstract class _$SessionExpired extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
