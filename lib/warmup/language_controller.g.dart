// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// SEBELUM (Riverpod 2, legacy di Riverpod 3):
/// ```dart
/// class LanguageNotifier extends StateNotifier<LanguageState> { ... }
/// final languageProvider =
///     StateNotifierProvider<LanguageNotifier, LanguageState>(...);
/// ```
///
/// SESUDAH: satu class beranotasi, provider `languageControllerProvider`
/// di-generate. Load awal dari storage jadi bagian `build()` yang async,
/// sehingga UI otomatis mendapat AsyncLoading/AsyncData — tidak perlu flag
/// `isLoading` manual seperti versi lama.

@ProviderFor(LanguageController)
final languageControllerProvider = LanguageControllerProvider._();

/// SEBELUM (Riverpod 2, legacy di Riverpod 3):
/// ```dart
/// class LanguageNotifier extends StateNotifier<LanguageState> { ... }
/// final languageProvider =
///     StateNotifierProvider<LanguageNotifier, LanguageState>(...);
/// ```
///
/// SESUDAH: satu class beranotasi, provider `languageControllerProvider`
/// di-generate. Load awal dari storage jadi bagian `build()` yang async,
/// sehingga UI otomatis mendapat AsyncLoading/AsyncData — tidak perlu flag
/// `isLoading` manual seperti versi lama.
final class LanguageControllerProvider
    extends $AsyncNotifierProvider<LanguageController, LanguageState> {
  /// SEBELUM (Riverpod 2, legacy di Riverpod 3):
  /// ```dart
  /// class LanguageNotifier extends StateNotifier<LanguageState> { ... }
  /// final languageProvider =
  ///     StateNotifierProvider<LanguageNotifier, LanguageState>(...);
  /// ```
  ///
  /// SESUDAH: satu class beranotasi, provider `languageControllerProvider`
  /// di-generate. Load awal dari storage jadi bagian `build()` yang async,
  /// sehingga UI otomatis mendapat AsyncLoading/AsyncData — tidak perlu flag
  /// `isLoading` manual seperti versi lama.
  LanguageControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'languageControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$languageControllerHash();

  @$internal
  @override
  LanguageController create() => LanguageController();
}

String _$languageControllerHash() =>
    r'a81f4ec47a2dd1953a3b27f83aba78842988b545';

/// SEBELUM (Riverpod 2, legacy di Riverpod 3):
/// ```dart
/// class LanguageNotifier extends StateNotifier<LanguageState> { ... }
/// final languageProvider =
///     StateNotifierProvider<LanguageNotifier, LanguageState>(...);
/// ```
///
/// SESUDAH: satu class beranotasi, provider `languageControllerProvider`
/// di-generate. Load awal dari storage jadi bagian `build()` yang async,
/// sehingga UI otomatis mendapat AsyncLoading/AsyncData — tidak perlu flag
/// `isLoading` manual seperti versi lama.

abstract class _$LanguageController extends $AsyncNotifier<LanguageState> {
  FutureOr<LanguageState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LanguageState>, LanguageState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LanguageState>, LanguageState>,
              AsyncValue<LanguageState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Derived provider: setara `currentLocaleProvider` versi lama.

@ProviderFor(currentLocale)
final currentLocaleProvider = CurrentLocaleProvider._();

/// Derived provider: setara `currentLocaleProvider` versi lama.

final class CurrentLocaleProvider
    extends $FunctionalProvider<Locale, Locale, Locale>
    with $Provider<Locale> {
  /// Derived provider: setara `currentLocaleProvider` versi lama.
  CurrentLocaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentLocaleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentLocaleHash();

  @$internal
  @override
  $ProviderElement<Locale> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Locale create(Ref ref) {
    return currentLocale(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale>(value),
    );
  }
}

String _$currentLocaleHash() => r'b10c33b5f4d72576a3e984ac9212c3cc209d2b42';
