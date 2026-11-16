// Hasil migrasi `LanguageNotifier extends StateNotifier` dari materi
// materis (implementasi/multi-language) ke Riverpod 3 + codegen.
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_controller.g.dart';

/// State immutable dengan primary constructor (Dart 3.13).
class const LanguageState(final Locale locale) {
  String get code => locale.languageCode;
}

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
@Riverpod(keepAlive: true)
class LanguageController extends _$LanguageController {
  static const _key = 'language_code';
  static const supported = [Locale('id'), Locale('en')];

  final _prefs = SharedPreferencesAsync();

  @override
  Future<LanguageState> build() async {
    final saved = await _prefs.getString(_key);
    return LanguageState(Locale(saved ?? 'id'));
  }

  Future<void> change(Locale locale) async {
    if (!supported.contains(locale)) return;
    state = AsyncData(LanguageState(locale)); // optimistic update
    await _prefs.setString(_key, locale.languageCode);
  }
}

/// Derived provider: setara `currentLocaleProvider` versi lama.
@riverpod
Locale currentLocale(Ref ref) =>
    ref.watch(languageControllerProvider).value?.locale ?? const Locale('id');
