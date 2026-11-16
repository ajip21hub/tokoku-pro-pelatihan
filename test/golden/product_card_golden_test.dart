import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:tokoku_pro/features/products/domain/product.dart';
import 'package:tokoku_pro/features/products/presentation/product_list_page.dart';

void main() {
  Widget card(Product p) =>
      SizedBox(width: 200, height: 280, child: ProductCard(product: p));

  // Satu file golden berisi beberapa skenario -> review visual sekaligus.
  goldenTest(
    'ProductCard dalam berbagai kondisi',
    fileName: 'product_card',
    builder: () => GoldenTestGroup(
      columns: 3,
      children: [
        GoldenTestScenario(
          name: 'normal',
          child: card(
            const Product(id: 1, title: 'Kopi Gayo 250g', price: 7.5),
          ),
        ),
        GoldenTestScenario(
          name: 'judul panjang',
          child: card(
            const Product(
              id: 2,
              title: 'Laptop Gaming Ultra Tipis 16 inci RTX Edisi Terbatas',
              price: 1299.99,
            ),
          ),
        ),
        GoldenTestScenario.withTextScaleFactor(
          name: 'teks 1.5x (aksesibilitas)',
          textScaler: const TextScaler.linear(1.5),
          child: card(const Product(id: 3, title: 'Teh Melati', price: 2)),
        ),
      ],
    ),
  );
}
