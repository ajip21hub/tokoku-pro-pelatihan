import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tokoku_pro/app.dart';

/// Jalankan di emulator/device:
///   flutter test integration_test/app_flow_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('login -> lihat katalog -> buka detail -> tambah ke keranjang', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: TokoKuApp()));
    await tester.pumpAndSettle();

    // Jika sudah login dari sesi sebelumnya, lewati langkah login
    if (find.byKey(const Key('login-button')).evaluate().isNotEmpty) {
      await tester.tap(find.byKey(const Key('login-button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));
    }

    expect(find.text('Katalog'), findsWidgets);
    await tester.tap(find.byType(Card).first);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.tap(find.text('Tambah ke Keranjang'));
    await tester.pumpAndSettle();
    expect(find.text('Ditambahkan ke keranjang'), findsOneWidget);
  });
}
