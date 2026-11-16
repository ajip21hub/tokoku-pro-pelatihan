import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:tokoku_pro/warmup/language_controller.dart';

void main() {
  // Ganti plugin SharedPreferences dengan versi in-memory (tanpa device).
  setUp(
    () => SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty(),
  );

  test('default bahasa Indonesia, lalu tersimpan setelah diganti', () async {
    final c1 = ProviderContainer.test();
    expect((await c1.read(languageControllerProvider.future)).code, 'id');

    await c1
        .read(languageControllerProvider.notifier)
        .change(const Locale('en'));
    expect(c1.read(currentLocaleProvider), const Locale('en'));

    // Container baru = app dibuka ulang -> nilai dibaca dari storage.
    final c2 = ProviderContainer.test();
    expect((await c2.read(languageControllerProvider.future)).code, 'en');
  });

  test('locale yang tidak didukung diabaikan', () async {
    final c = ProviderContainer.test();
    await c.read(languageControllerProvider.future);
    await c
        .read(languageControllerProvider.notifier)
        .change(const Locale('fr'));
    expect(c.read(currentLocaleProvider), const Locale('id'));
  });
}
