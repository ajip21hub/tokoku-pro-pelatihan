import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/failure.dart';
import '../domain/product.dart';
import 'product_remote_data_source.dart';

part 'product_repository.g.dart';

/// Versi Hari 1: remote saja. Pada Hari 3, cache drift (offline-first)
/// ditambahkan ke kelas ini tanpa mengubah UI sama sekali.
class ProductRepository {
  ProductRepository(this._remote);
  final ProductRemoteDataSource _remote;

  Future<ProductPage> getPage({
    required int limit,
    required int skip,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _remote.fetchPage(
        limit: limit,
        skip: skip,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw mapDioError(e); // DioException -> Failure
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
}

@Riverpod(keepAlive: true)
ProductRepository productRepository(Ref ref) =>
    ProductRepository(ref.watch(productRemoteDataSourceProvider));
