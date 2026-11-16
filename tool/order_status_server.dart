// Server WebSocket mini untuk Lab Hari 3 (murni dart:io, tanpa paket).
//
//   dart run tool/order_status_server.dart          # port 8080
//
// Emulator Android mengakses komputer Anda lewat ws://10.0.2.2:8080.
// Setiap koneksi ke /orders/<id> menerima status bertahap tiap 3 detik.
// Kirim teks "drop" dari klien untuk mensimulasikan koneksi putus.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

const _steps = ['created', 'processing', 'shipped', 'delivered'];

/// Progres per pesanan disimpan agar reconnect melanjutkan status terakhir.
final _progress = <String, int>{};

Future<void> main(List<String> args) async {
  final port = args.isNotEmpty ? int.parse(args.first) : 8080;
  final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
  stdout.writeln('Order status server: ws://localhost:$port/orders/<id>');

  await for (final request in server) {
    final segments = request.uri.pathSegments;
    if (segments.length != 2 || segments.first != 'orders') {
      request.response.statusCode = HttpStatus.notFound;
      await request.response.close();
      continue;
    }
    final orderId = segments[1];
    final socket = await WebSocketTransformer.upgrade(request);
    stdout.writeln('+ $orderId terhubung');

    void send() {
      final i = _progress[orderId] ?? 0;
      socket.add(jsonEncode({'orderId': orderId, 'status': _steps[i]}));
    }

    send();
    final timer = Timer.periodic(const Duration(seconds: 3), (t) {
      final next = (_progress[orderId] ?? 0) + 1;
      if (next >= _steps.length) {
        t.cancel();
        unawaited(socket.close());
        return;
      }
      _progress[orderId] = next;
      send();
    });

    socket.listen(
      (msg) {
        if (msg == 'drop') socket.close(WebSocketStatus.goingAway);
      },
      onDone: () {
        timer.cancel();
        stdout.writeln('- $orderId terputus');
      },
    );
  }
}
