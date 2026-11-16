import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:tokoku_pro/app.dart';

/// Memastikan starter terpasang dengan benar sebelum Lab Capstone 1.
void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  testWidgets('starter menampilkan form login dan memvalidasi input', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: TokoKuApp()));
    await tester.pumpAndSettle();

    expect(find.text('TokoKu Pro'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('username')), '');
    await tester.tap(find.byKey(const Key('login-button')));
    await tester.pump();
    expect(find.text('Wajib diisi'), findsOneWidget);
  });
}
