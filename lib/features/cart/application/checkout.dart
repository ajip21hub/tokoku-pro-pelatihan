import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/app_database.dart';

part 'checkout.g.dart';

/// Use case: satu aksi pengguna yang mengoordinasikan beberapa dependensi
/// (database keranjang dan ID pesanan; analytics menyusul di Hari 5). Sebelumnya logika ini
/// tercecer di `onPressed` tombol Checkout sehingga sulit diuji.
///
/// Tidak setiap fitur butuh use case. Jika isinya hanya meneruskan panggilan
/// ke satu repository, panggil repository langsung dari controller.
class Checkout {
  Checkout(this._db, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _now;

  /// Mengembalikan ID pesanan. Demo: ID dibuat lokal; di app nyata ID ini
  /// berasal dari response API pembuatan pesanan.
  Future<String> call() async {
    final items = await _db.watchCart().first;
    if (items.isEmpty) throw StateError('Keranjang kosong');

    final orderId = 'ORD-${_now().millisecondsSinceEpoch}';
    await _db.clearCart();
    return orderId;
  }
}

@riverpod
Checkout checkout(Ref ref) =>
    Checkout(ref.watch(appDatabaseProvider));
