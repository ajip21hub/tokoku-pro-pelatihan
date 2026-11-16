import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'product_search_controller.dart';

class ProductSearchPage extends ConsumerStatefulWidget {
  const ProductSearchPage({super.key});

  @override
  ConsumerState<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends ConsumerState<ProductSearchPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(productSearchProvider(_query));
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Cari produk…',
            border: InputBorder.none,
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
      ),
      body: switch (results) {
        AsyncData(:final value) when value.isEmpty => const Center(
          child: Text('Ketik minimal 2 huruf'),
        ),
        AsyncData(:final value) => ListView.builder(
          itemCount: value.length,
          itemBuilder: (_, i) => ListTile(
            title: Text(value[i].title),
            subtitle: Text('\$${value[i].price}'),
            onTap: () => context.push('/products/${value[i].id}'),
          ),
        ),
        AsyncError(:final error) => Center(child: Text('$error')),
        _ => const LinearProgressIndicator(),
      },
    );
  }
}
