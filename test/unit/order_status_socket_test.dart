import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tokoku_pro/features/orders/data/order_status_socket.dart';
import 'package:tokoku_pro/features/orders/domain/order_status.dart';

String msg(String status) => jsonEncode({'orderId': 'A1', 'status': status});

void main() {
  test(
    'reconnect otomatis setelah koneksi putus, lalu berhenti di status final',
    () async {
      var connections = 0;
      final socket = OrderStatusSocket(
        baseUri: Uri.parse('ws://test'),
        backoff: (_) => Duration.zero, // test cepat
        connector: (uri) {
          connections++;
          expect(uri.path, '/orders/A1');
          return switch (connections) {
            // Koneksi 1: dapat 2 status lalu PUTUS (error jaringan).
            1 => Stream.fromIterable([
              msg('created'),
              msg('processing'),
            ]).followedBy(Stream.error(Exception('socket closed'))),
            // Koneksi 2: pesan sampah diabaikan, lanjut sampai selesai.
            _ => Stream.fromIterable([
              'bukan json',
              msg('shipped'),
              msg('delivered'),
            ]),
          };
        },
      );

      final statuses = await socket.watch('A1').toList();

      expect(statuses, [
        OrderStatus.created,
        OrderStatus.processing,
        OrderStatus.shipped,
        OrderStatus.delivered,
      ]);
      expect(connections, 2);
    },
  );

  test('tryParse memakai pattern matching Map', () {
    expect(OrderStatus.tryParse(msg('shipped')), OrderStatus.shipped);
    expect(OrderStatus.tryParse('{"status": 42}'), isNull);
    expect(OrderStatus.tryParse('{}'), isNull);
  });
}

extension<T> on Stream<T> {
  Stream<T> followedBy(Stream<T> next) async* {
    yield* this;
    yield* next;
  }
}
