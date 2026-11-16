import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/app_database.dart';
import '../../../core/error/failure.dart';
import '../domain/product.dart';
import 'product_remote_data_source.dart';

part 'product_repository.g.dart';

/// Strategi offline-first: "network first, fallback ke cache".
/// Berhasil dari network -> simpan ke cache. Gagal karena jaringan ->
/// kembalikan data cache (fromCache: true) agar UI tetap berguna.
class ProductRepository {
  ProductRepository(this._remote, this._db);
  final ProductRemoteDataSource _remote;
  final AppDatabase _db;

  Future<ProductPage> getPage({
    required int limit,
    required int skip,
    CancelToken? cancelToken,
  }) async {
    try {
      final page = await _remote.fetchPage(
        limit: limit,
        skip: skip,
        cancelToken: cancelToken,
      );
      await _db.upsertProducts(page.items.map(_toRow).toList());
      return page;
    } catch (e) {
      final failure = mapDioError(e);
      if (failure is! NetworkFailure) throw failure;
      final cached = await _db.productsPage(limit: limit, offset: skip);
      if (cached.isEmpty && skip == 0) throw failure;
      return ProductPage(
        items: cached.map(_fromRow).toList(),
        total: skip + cached.length, // saat offline tidak tahu total sebenarnya
        fromCache: true,
      );
    }
  }

  Future<ProductPage> search(String q, {CancelToken? cancelToken}) async {
    try {
      return await _remote.search(q, cancelToken: cancelToken);
    } catch (e) {
      throw mapDioError(e);
    }
  }

  Future<Product> detail(int id) async {
    try {
      return await _remote.fetchDetail(id);
    } catch (e) {
      throw mapDioError(e);
    }
  }

  static CachedProductsCompanion _toRow(Product p) => CachedProductsCompanion(
    id: Value(p.id),
    title: Value(p.title),
    description: Value(p.description),
    category: Value(p.category),
    price: Value(p.price),
    rating: Value(p.rating),
    stock: Value(p.stock),
    thumbnail: Value(p.thumbnail),
  );

  static Product _fromRow(CachedProduct r) => Product(
    id: r.id,
    title: r.title,
    description: r.description,
    category: r.category,
    price: r.price,
    rating: r.rating,
    stock: r.stock,
    thumbnail: r.thumbnail,
  );
}

@Riverpod(keepAlive: true)
ProductRepository productRepository(Ref ref) => ProductRepository(
  ref.watch(productRemoteDataSourceProvider),
  ref.watch(appDatabaseProvider),
);
