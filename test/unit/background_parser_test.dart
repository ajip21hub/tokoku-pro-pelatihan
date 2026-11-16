import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tokoku_pro/core/utils/background_parser.dart';

void main() {
  test('parse 5.000 produk di background', () async {
    final body = jsonEncode({
      'products': [
        for (var i = 0; i < 5000; i++) {'id': i, 'title': 'P$i', 'price': i},
      ],
    });
    final products = await parseProductsInBackground(body);
    expect(products, hasLength(5000));
    expect(products.last.price, 4999.0); // int JSON -> double otomatis
  });
}
