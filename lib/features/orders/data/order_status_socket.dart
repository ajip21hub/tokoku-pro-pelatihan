import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../core/config/env.dart';
import '../domain/order_status.dart';

part 'order_status_socket.g.dart';

/// Membuka koneksi dan mengalirkan pesan teks. Dibuat sebagai fungsi agar
/// bisa diganti di test (tanpa server sungguhan).
typedef MessageConnector = Stream<String> Function(Uri uri);

/// Implementasi nyata: WebSocket. `finally` di generator `async*` dijalankan
/// saat subscriber berhenti mendengarkan -> socket selalu ditutup.
Stream<String> webSocketConnector(Uri uri) async* {
  final channel = WebSocketChannel.connect(uri);
  try {
    await channel.ready;
    yield* channel.stream.map((m) => m.toString());
  } finally {
    await channel.sink.close();
  }
}

/// Real-time status pesanan dengan reconnect otomatis (exponential backoff).
///
/// Pola penting koneksi real-time di mobile: jaringan seluler SERING putus
/// (pindah BTS, masuk lift). Tanpa reconnect, UI diam selamanya.
class OrderStatusSocket {
  OrderStatusSocket({
    required this.baseUri,
    MessageConnector connector = webSocketConnector,
    Duration Function(int attempt)? backoff,
  }) : _connect = connector,
       _backoff = backoff ?? _defaultBackoff;

  final Uri baseUri;
  final MessageConnector _connect;
  final Duration Function(int attempt) _backoff;

  /// 1s, 2s, 4s, 8s ... maks 30s.
  static Duration _defaultBackoff(int attempt) =>
      Duration(seconds: min(30, pow(2, attempt - 1).toInt()));

  Stream<OrderStatus> watch(String orderId) async* {
    final uri = baseUri.replace(path: '/orders/$orderId');
    var attempt = 0;
    while (true) {
      try {
        await for (final message in _connect(uri)) {
          attempt = 0; // koneksi sehat -> reset backoff
          final status = OrderStatus.tryParse(message);
          if (status == null) continue; // abaikan pesan tak dikenal
          yield status;
          if (status.isFinal) return; // selesai, tidak perlu reconnect
        }
      } catch (e) {
        debugPrint('WebSocket putus: $e');
      }
      attempt++;
      await Future<void>.delayed(_backoff(attempt));
    }
  }
}

@Riverpod(keepAlive: true)
OrderStatusSocket orderStatusSocket(Ref ref) =>
    OrderStatusSocket(baseUri: Uri.parse(Env.wsBaseUrl));

/// autoDispose: keluar dari halaman -> subscription dibatalkan -> socket ditutup.
@riverpod
Stream<OrderStatus> orderStatus(Ref ref, String orderId) =>
    ref.watch(orderStatusSocketProvider).watch(orderId);
