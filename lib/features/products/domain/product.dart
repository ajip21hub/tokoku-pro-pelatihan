import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    required int id,
    required String title,
    @Default('') String description,
    @Default('') String category,
    required double price,
    @Default(0) double rating,
    @Default(0) int stock,
    @Default('') String thumbnail,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

/// Satu halaman hasil paginasi dari API.
@freezed
abstract class ProductPage with _$ProductPage {
  const factory ProductPage({
    required List<Product> items,
    required int total,
    @Default(false) bool fromCache,
  }) = _ProductPage;
}
