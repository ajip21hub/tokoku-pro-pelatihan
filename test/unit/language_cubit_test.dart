import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:tokoku_pro/warmup/language_cubit.dart';

void main() {
  setUp(
    () => SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty(),
  );

  test('state awal null, lalu berisi bahasa default setelah load()', () async {
    final cubit = LanguageCubit();
    addTearDown(cubit.close);

    expect(cubit.state, isNull);
    await cubit.load();
    expect(cubit.state?.code, 'id');
  });

  test('change() memancarkan state baru dan menyimpannya', () async {
    final cubit = LanguageCubit();
    addTearDown(cubit.close);

    // Cubit adalah Stream: urutan state bisa diuji tanpa paket tambahan.
    final emitted = expectLater(
      cubit.stream.map((s) => s?.code),
      emitsInOrder(['id', 'en']),
    );
    await cubit.load();
    await cubit.change(const Locale('en'));
    await emitted;

    // Cubit baru = app dibuka ulang -> nilai dibaca dari storage.
    final reopened = LanguageCubit();
    addTearDown(reopened.close);
    await reopened.load();
    expect(reopened.state?.code, 'en');
  });

  test('locale yang tidak didukung diabaikan', () async {
    final cubit = LanguageCubit();
    addTearDown(cubit.close);
    await cubit.load();

    await cubit.change(const Locale('fr'));
    expect(cubit.state?.code, 'id');
  });
}
