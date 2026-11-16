import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tokoku_pro/core/error/failure.dart';
import 'package:tokoku_pro/features/products/data/product_repository.dart';
import 'package:tokoku_pro/features/products/domain/product.dart';
import 'package:tokoku_pro/features/products/presentation/product_list_page.dart';
import 'package:tokoku_pro/l10n/app_localizations.dart';

import '../helpers/fakes.dart';

void main() {
  late MockProductRepository repo;
  setUp(() => repo = MockProductRepository());

  Widget harness() => ProviderScope(
    overrides: [productRepositoryProvider.overrideWithValue(repo)],
    // Matikan auto-retry Riverpod 3 agar error langsung tampil di test
    retry: (_, _) => null,
    child: const MaterialApp(
      locale: Locale('id'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ProductListPage(),
    ),
  );

  testWidgets('menampilkan grid produk', (tester) async {
    when(
      () => repo.getPage(
        limit: any(named: 'limit'),
        skip: any(named: 'skip'),
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((_) async => ProductPage(items: fakeProducts(4), total: 4));

    await tester.pumpWidget(harness());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(ProductCard), findsNWidgets(4));
    expect(find.text('Produk 1'), findsOneWidget);
  });

  testWidgets('menampilkan pesan error + tombol coba lagi', (tester) async {
    when(
      () => repo.getPage(
        limit: any(named: 'limit'),
        skip: any(named: 'skip'),
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenThrow(const NetworkFailure());

    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    expect(find.text('Tidak ada koneksi internet'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Coba lagi'), findsOneWidget);
  });
}
