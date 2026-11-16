import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../features/products/domain/product.dart';

/// Parsing JSON besar di isolate lain agar UI thread tidak "jank".
/// `compute` bekerja di semua platform (di web berjalan di thread yang sama).
/// Untuk mobile/desktop saja, `Isolate.run(() => ...)` juga bisa dipakai.
Future<List<Product>> parseProductsInBackground(String responseBody) =>
    compute(_parseProducts, responseBody);

List<Product> _parseProducts(String body) {
  final json = jsonDecode(body) as Map<String, dynamic>;
  return (json['products'] as List)
      .cast<Map<String, dynamic>>()
      .map(Product.fromJson)
      .toList();
}
