import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tokoku_pro/core/database/app_database.dart';
import 'package:tokoku_pro/core/error/failure.dart';
import 'package:tokoku_pro/features/products/data/product_repository.dart';
import 'package:tokoku_pro/features/products/domain/product.dart';

import '../helpers/fakes.dart';

void main() {
  late MockRemote remote;
  late AppDatabase db;
  late ProductRepository repo;

  setUp(() {
    remote = MockRemote();
    db = AppDatabase(
      NativeDatabase.memory(),
    ); // DB in-memory: cepat & terisolasi
    repo = ProductRepository(remote, db);
  });

  tearDown(() => db.close());

  DioException offline() => DioException(
    requestOptions: RequestOptions(path: '/products'),
    type: DioExceptionType.connectionError,
  );

  test('online: mengembalikan data API dan menyimpannya ke cache', () async {
    when(
      () => remote.fetchPage(
        limit: 20,
        skip: 0,
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((_) async => ProductPage(items: fakeProducts(3), total: 3));

    final page = await repo.getPage(limit: 20, skip: 0);

    expect(page.items, hasLength(3));
    expect(page.fromCache, isFalse);
    expect(await db.productsPage(limit: 20, offset: 0), hasLength(3));
  });

  test('offline: fallback ke cache dengan flag fromCache', () async {
    when(
      () => remote.fetchPage(
        limit: 20,
        skip: 0,
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((_) async => ProductPage(items: fakeProducts(2), total: 2));
    await repo.getPage(limit: 20, skip: 0); // isi cache

    when(
      () => remote.fetchPage(
        limit: 20,
        skip: 0,
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenThrow(offline());
    final page = await repo.getPage(limit: 20, skip: 0);

    expect(page.fromCache, isTrue);
    expect(page.items.map((p) => p.title), ['Produk 1', 'Produk 2']);
  });

  test('offline & cache kosong: melempar NetworkFailure', () async {
    when(
      () => remote.fetchPage(
        limit: 20,
        skip: 0,
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenThrow(offline());

    expect(
      () => repo.getPage(limit: 20, skip: 0),
      throwsA(isA<NetworkFailure>()),
    );
  });
}
