import 'package:mocktail/mocktail.dart';
import 'package:tokoku_pro/features/products/data/product_remote_data_source.dart';
import 'package:tokoku_pro/features/products/data/product_repository.dart';
import 'package:tokoku_pro/features/products/domain/product.dart';

class MockRemote extends Mock implements ProductRemoteDataSource {}

class MockProductRepository extends Mock implements ProductRepository {}

List<Product> fakeProducts(int n, {int start = 1}) => [
  for (var i = start; i < start + n; i++)
    Product(id: i, title: 'Produk $i', price: i * 1.5, thumbnail: ''),
];
