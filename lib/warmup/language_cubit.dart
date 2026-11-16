// Pembanding Hari 1 (Sesi 6): fitur yang sama dengan LanguageController,
// ditulis dengan Cubit (flutter_bloc). Tujuannya agar peserta bisa membaca
// dan merawat kode BLoC yang masih banyak dipakai di proyek lain.
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'language_controller.dart' show LanguageController, LanguageState;

/// Cubit tidak punya AsyncValue bawaan, jadi status loading dimodelkan
/// sendiri. Di sini `null` berarti bahasa tersimpan belum selesai dibaca.
class LanguageCubit extends Cubit<LanguageState?> {
  LanguageCubit({SharedPreferencesAsync? prefs})
    : _prefs = prefs ?? SharedPreferencesAsync(),
      super(null);

  static const _key = 'language_code';
  final SharedPreferencesAsync _prefs;

  /// Dipanggil manual oleh pembuat cubit: `LanguageCubit()..load()`.
  Future<void> load() async {
    final saved = await _prefs.getString(_key);
    emit(LanguageState(Locale(saved ?? 'id')));
  }

  Future<void> change(Locale locale) async {
    if (!LanguageController.supported.contains(locale)) return;
    emit(LanguageState(locale)); // optimistic update
    await _prefs.setString(_key, locale.languageCode);
  }
}
