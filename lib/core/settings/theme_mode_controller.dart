import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_mode_controller.g.dart';

/// Preferensi ringan (bukan rahasia) -> SharedPreferencesAsync.
/// API async baru ini menggantikan `SharedPreferences.getInstance()`.
@Riverpod(keepAlive: true)
class ThemeModeController extends _$ThemeModeController {
  static const _key = 'theme_mode';
  final _prefs = SharedPreferencesAsync();

  @override
  Future<ThemeMode> build() async {
    final saved = await _prefs.getString(_key);
    return ThemeMode.values.asNameMap()[saved] ?? ThemeMode.system;
  }

  Future<void> set(ThemeMode mode) async {
    state = AsyncData(mode); // optimistic update
    await _prefs.setString(_key, mode.name);
  }
}
