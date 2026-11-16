import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_client.dart';
import '../domain/product.dart';

part 'product_remote_data_source.g.dart';

class ProductRemoteDataSource {
  ProductRemoteDataSource(this._dio);
  final Dio _dio;

  static const _fields =
      'title,description,category,price,rating,stock,thumbnail';

  Future<ProductPage> fetchPage({
    required int limit,
    required int skip,
    CancelToken? cancelToken,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/products',
      queryParameters: {'limit': limit, 'skip': skip, 'select': _fields},
      cancelToken: cancelToken,
    );
    return _toPage(res.data!);
  }

  Future<ProductPage> search(String query, {CancelToken? cancelToken}) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/products/search',
      queryParameters: {'q': query, 'select': _fields},
      cancelToken: cancelToken,
    );
    return _toPage(res.data!);
  }

  Future<Product> fetchDetail(int id) async {
    final res = await _dio.get<Map<String, dynamic>>('/products/$id');
    return Product.fromJson(res.data!);
  }

  ProductPage _toPage(Map<String, dynamic> json) => ProductPage(
    items: (json['products'] as List)
        .cast<Map<String, dynamic>>()
        .map(Product.fromJson)
        .toList(),
    total: json['total'] as int,
  );
}

@Riverpod(keepAlive: true)
ProductRemoteDataSource productRemoteDataSource(Ref ref) =>
    ProductRemoteDataSource(ref.watch(dioProvider));
