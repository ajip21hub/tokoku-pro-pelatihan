import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tokoku_core/tokoku_core.dart';

import '../../../router/app_router.dart';
import '../application/checkout.dart';
import 'cart_providers.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartItemsProvider);
    final summary = ref.watch(cartSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Keranjang (${summary.count})')),
      body: switch (items) {
        AsyncData(:final value) when value.isEmpty => const Center(
          child: Text('Keranjang masih kosong'),
        ),
        AsyncData(:final value) => ListView.separated(
          itemCount: value.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final item = value[i];
            return Dismissible(
              key: ValueKey(item.productId),
              direction: .endToStart,
              onDismissed: (_) =>
                  ref.read(cartActionsProvider).remove(item.productId),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: ListTile(
                title: Text(item.title),
                subtitle: Text(
                  '${item.qty} × ${Money.fromDecimal(item.price, .usd)}',
                ),
                trailing: Icon(
                  item.synced ? Icons.cloud_done : Icons.cloud_upload_outlined,
                  semanticLabel: item.synced ? 'Tersinkron' : 'Menunggu sync',
                ),
              ),
            );
          },
        ),
        AsyncError(:final error) => Center(child: Text('$error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Total: ${summary.total.format()}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              FilledButton.icon(
                key: const Key('checkout-button'),
                icon: const Icon(Icons.payments_outlined),
                label: const Text('Checkout'),
                onPressed: summary.count == 0
                    ? null
                    : () async {
                        // Logika checkout ada di use case, bukan di widget.
                        final id = await ref.read(checkoutProvider).call();
                        if (!context.mounted) return;
                        unawaited(context.push(Routes.order(id)));
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
