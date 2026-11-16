import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/order_status_socket.dart';
import '../domain/order_status.dart';

class OrderStatusPage extends ConsumerWidget {
  const OrderStatusPage({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(orderStatusProvider(orderId));
    // Selama reconnect, stream tidak memancarkan apa pun -> AsyncData terakhir
    // tetap tampil (UI tidak "berkedip" kembali ke loading).
    final current = status.value;

    return Scaffold(
      appBar: AppBar(title: Text('Pesanan $orderId')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final step in OrderStatus.values)
            ListTile(
              leading: Icon(
                current != null && step.index <= current.index
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: current == step
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              title: Text(step.label),
            ),
          const SizedBox(height: 16),
          switch (status) {
            AsyncError(:final error) => Text('Koneksi bermasalah: $error'),
            AsyncData(value: OrderStatus(isFinal: true)) => const Text(
              'Terima kasih sudah berbelanja',
            ),
            _ => const LinearProgressIndicator(),
          },
        ],
      ),
    );
  }
}
