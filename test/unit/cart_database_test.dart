import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokoku_pro/core/database/app_database.dart';

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  CartItemsCompanion item(int id) => CartItemsCompanion.insert(
    productId: Value(id),
    title: 'P$id',
    price: 10,
    thumbnail: '',
  );

  test('menambah produk yang sama menaikkan qty', () async {
    await db.addToCart(item(1));
    await db.addToCart(item(1));
    final cart = await db.watchCart().first;
    expect(cart.single.qty, 2);
  });

  test('markSynced mengubah status item yang dikirim', () async {
    await db.addToCart(item(1));
    await db.addToCart(item(2));
    await db.markSynced({1: 1});
    final pending = await db.unsyncedCart();
    expect(pending.map((e) => e.productId), [2]);
  });

  test(
    'qty berubah SAAT sync berjalan -> item tetap belum tersinkron',
    () async {
      await db.addToCart(item(1));
      final sent = {
        for (final i in await db.unsyncedCart()) i.productId: i.qty,
      };

      await db.addToCart(item(1)); // user menambah lagi sebelum response datang
      final marked = await db.markSynced(sent);

      expect(marked, 0);
      final pending = await db.unsyncedCart();
      expect(pending.single.qty, 2); // akan ikut terkirim di sync berikutnya
    },
  );
}
