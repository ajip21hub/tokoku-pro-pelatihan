import 'package:flutter/material.dart';

/// STUB Hari 2: status pesanan live dibuat pada Lab 3C.
class OrderStatusPage extends StatelessWidget {
  const OrderStatusPage({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Pesanan $orderId')),
    body: const Center(child: Text('Hari 3')),
  );
}
