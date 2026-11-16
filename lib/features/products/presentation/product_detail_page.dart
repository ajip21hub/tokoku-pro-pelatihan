import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tokoku_core/tokoku_core.dart';

import '../../cart/presentation/cart_providers.dart';
import 'product_list_controller.dart';

class ProductDetailPage extends ConsumerWidget {
  const ProductDetailPage({super.key, required this.productId});
  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productDetailProvider(productId));
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk')),
      body: switch (product) {
        AsyncData(:final value) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Hero(
              tag: 'product-${value.id}',
              child: AspectRatio(
                aspectRatio: 1,
                child: CachedNetworkImage(
                  imageUrl: value.thumbnail,
                  fit: .contain,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(value.title, style: Theme.of(context).textTheme.headlineSmall),
            Text(
              '${Money.fromDecimal(value.price, .usd)} • ${value.category} • '
              'Rating ${value.rating} • stok ${value.stock}',
            ),
            const SizedBox(height: 8),
            Text(value.description),
          ],
        ),
        AsyncError(:final error) => Center(child: Text('$error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
      bottomNavigationBar: product.hasValue
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: FilledButton.icon(
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Tambah ke Keranjang'),
                  onPressed: () async {
                    await ref
                        .read(cartActionsProvider)
                        .add(product.requireValue);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ditambahkan ke keranjang')),
                    );
                  },
                ),
              ),
            )
          : null,
    );
  }
}
