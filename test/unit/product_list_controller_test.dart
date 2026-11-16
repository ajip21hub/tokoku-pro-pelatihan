import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tokoku_pro/features/products/data/product_repository.dart';
import 'package:tokoku_pro/features/products/domain/product.dart';
import 'package:tokoku_pro/features/products/presentation/product_list_controller.dart';

import '../helpers/fakes.dart';

void main() {
  late MockProductRepository repo;

  setUp(() {
    repo = MockProductRepository();
    when(
      () => repo.getPage(
        limit: 20,
        skip: 0,
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((_) async => ProductPage(items: fakeProducts(20), total: 25));
    when(() => repo.getPage(limit: 20, skip: 20)).thenAnswer(
      (_) async => ProductPage(items: fakeProducts(5, start: 21), total: 25),
    );
  });

  ProviderContainer makeContainer() => ProviderContainer.test(
    overrides: [productRepositoryProvider.overrideWithValue(repo)],
  );

  test('build() memuat halaman pertama', () async {
    final container = makeContainer();
    final sub = container.listen(productListControllerProvider, (_, _) {});

    final state = await container.read(productListControllerProvider.future);

    expect(state.items, hasLength(20));
    expect(state.hasMore, isTrue);
    sub.close();
  });

  test('loadMore() menambahkan halaman berikutnya', () async {
    final container = makeContainer();
    final sub = container.listen(productListControllerProvider, (_, _) {});
    await container.read(productListControllerProvider.future);

    await container.read(productListControllerProvider.notifier).loadMore();

    final state = container.read(productListControllerProvider).requireValue;
    expect(state.items, hasLength(25));
    expect(state.hasMore, isFalse);
    sub.close();
  });
}
