import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tokoku_pro/features/products/data/product_repository.dart';
import 'package:tokoku_pro/features/products/domain/product.dart';
import 'package:tokoku_pro/features/products/presentation/product_list_page.dart';
import 'package:tokoku_pro/l10n/app_localizations.dart';

import '../helpers/fakes.dart';

void main() {
  late MockProductRepository repo;

  setUp(() {
    repo = MockProductRepository();
    when(
      () => repo.getPage(
        limit: any(named: 'limit'),
        skip: any(named: 'skip'),
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((_) async => ProductPage(items: fakeProducts(4), total: 4));
  });

  Widget harness({Locale locale = const Locale('id'), double textScale = 1}) =>
      ProviderScope(
        overrides: [productRepositoryProvider.overrideWithValue(repo)],
        retry: (_, _) => null,
        child: MaterialApp(
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
          home: const ProductListPage(),
        ),
      );

  /// Ukuran ponsel kecil (360 × 640 dp), bukan layar test default 800 × 600.
  void usePhoneSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  testWidgets('katalog memenuhi pedoman aksesibilitas', (tester) async {
    final semantics = tester.ensureSemantics();
    usePhoneSize(tester);
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    semantics.dispose();
  });

  testWidgets('kartu produk dibaca sebagai satu tombol', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    expect(
      tester.getSemantics(find.byType(ProductCard).first),
      isSemantics(label: 'Produk 1\n\$1.50', hasTapAction: true),
    );
    semantics.dispose();
  });

  testWidgets('teks diperbesar 200% tidak menyebabkan overflow', (
    tester,
  ) async {
    usePhoneSize(tester);
    await tester.pumpWidget(harness(textScale: 2));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(ProductCard), findsWidgets);
  });

  testWidgets('bahasa Inggris memakai string dari app_en.arb', (tester) async {
    await tester.pumpWidget(harness(locale: const Locale('en')));
    await tester.pumpAndSettle();

    expect(find.text('Catalog'), findsOneWidget);
    expect(find.byTooltip('Search'), findsOneWidget);
  });
}
