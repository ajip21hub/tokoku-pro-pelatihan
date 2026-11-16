import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/cart/domain/cart_line.dart';
import 'database_key.dart';

part 'app_database.g.dart';

/// Cache katalog (offline-first). Disimpan sebagai kolom terstruktur.
class CachedProducts extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get category => text()();
  RealColumn get price => real()();
  RealColumn get rating => real()();
  IntColumn get stock => integer()();
  TextColumn get thumbnail => text()();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Keranjang belanja lokal — tetap bisa dipakai saat offline.
@UseRowClass(CartLine)
class CartItems extends Table {
  IntColumn get productId => integer()();
  TextColumn get title => text()();
  RealColumn get price => real()();
  TextColumn get thumbnail => text()();
  IntColumn get qty => integer().withDefault(const Constant(1))();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {productId};
}

@DriftDatabase(tables: [CachedProducts, CartItems])
class AppDatabase extends _$AppDatabase {
  /// Tanpa argumen: file `tokoku.sqlite` terenkripsi. Test memberi executor
  /// sendiri (mis. `NativeDatabase.memory()`).
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openEncrypted());

  /// Kunci dibaca secara async, jadi koneksi dibuat tertunda (`delayed`).
  static QueryExecutor _openEncrypted() => DatabaseConnection.delayed(
    Future(() async {
      final key = await DatabaseKeyStore(const FlutterSecureStorage()).obtain();
      return driftDatabase(
        name: 'tokoku',
        native: DriftNativeOptions(
          // Background sync (workmanager) berjalan di isolate lain ->
          // izinkan beberapa isolate memakai file DB yang sama dengan aman.
          shareAcrossIsolates: true,
          setup: (db) => applyEncryption(db, key),
        ),
      );
    }),
  );

  @override
  int get schemaVersion => 1;

  // ---------- Produk ----------
  Future<void> upsertProducts(List<CachedProductsCompanion> rows) =>
      batch((b) => b.insertAllOnConflictUpdate(cachedProducts, rows));

  Future<List<CachedProduct>> productsPage({
    required int limit,
    required int offset,
  }) =>
      (select(cachedProducts)
            ..orderBy([(t) => OrderingTerm.asc(t.id)])
            ..limit(limit, offset: offset))
          .get();

  // ---------- Keranjang ----------
  Stream<List<CartLine>> watchCart() => select(cartItems).watch();

  Future<void> addToCart(CartItemsCompanion item) async {
    final existing =
        await (select(cartItems)
              ..where((t) => t.productId.equals(item.productId.value)))
            .getSingleOrNull();
    if (existing == null) {
      await into(cartItems).insert(item);
    } else {
      await (update(
        cartItems,
      )..where((t) => t.productId.equals(existing.productId))).write(
        CartItemsCompanion(
          qty: Value(existing.qty + 1),
          synced: const Value(false),
        ),
      );
    }
  }

  Future<void> removeFromCart(int productId) =>
      (delete(cartItems)..where((t) => t.productId.equals(productId))).go();

  Future<List<CartLine>> unsyncedCart() =>
      (select(cartItems)..where((t) => t.synced.equals(false))).get();

  /// Tandai tersinkron HANYA jika qty belum berubah sejak dikirim.
  /// Jika user menambah qty saat request sync berjalan, item tetap
  /// `synced=false` dan ikut terkirim di sync berikutnya (tidak hilang).
  Future<int> markSynced(Map<int, int> sentQtyByProductId) => transaction(
    () async {
      var updated = 0;
      for (final MapEntry(key: id, value: qty) in sentQtyByProductId.entries) {
        updated +=
            await (update(cartItems)
                  ..where((t) => t.productId.equals(id) & t.qty.equals(qty)))
                .write(const CartItemsCompanion(synced: Value(true)));
      }
      return updated;
    },
  );

  Future<void> clearCart() => delete(cartItems).go();
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}
