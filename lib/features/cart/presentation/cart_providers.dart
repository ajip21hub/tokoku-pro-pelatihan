import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tokoku_core/tokoku_core.dart';

import '../../../core/analytics/analytics_service.dart';
import '../../../core/database/app_database.dart';
import '../../products/domain/product.dart';
import '../data/cart_sync_service.dart';
import '../domain/cart_line.dart';

part 'cart_providers.g.dart';

/// Stream reaktif dari drift: UI otomatis update saat tabel berubah.
@riverpod
Stream<List<CartLine>> cartItems(Ref ref) =>
    ref.watch(appDatabaseProvider).watchCart();

/// Derived state: jumlah item & total (pakai `Money`, bukan double).
@riverpod
({int count, Money total}) cartSummary(Ref ref) {
  final items = ref.watch(cartItemsProvider).value ?? const [];
  return (
    count: items.fold(0, (sum, i) => sum + i.qty),
    total: items.fold(
      Money.zero(.usd),
      (sum, i) => sum + Money.fromDecimal(i.price, .usd) * i.qty,
    ),
  );
}

class CartActions {
  CartActions(this._db, this._sync, this._analytics);
  final AppDatabase _db;
  final CartSyncService _sync;
  final AnalyticsService _analytics;

  /// Simpan lokal dulu (UI langsung update), lalu coba sync di belakang.
  Future<void> add(Product p) async {
    await _db.addToCart(
      CartItemsCompanion.insert(
        productId: Value(p.id),
        title: p.title,
        price: p.price,
        thumbnail: p.thumbnail,
      ),
    );
    _analytics.addToCart(p).ignore();
    unawaited(_sync.syncNow());
  }

  Future<void> remove(int productId) => _db.removeFromCart(productId);

  Future<void> clear() => _db.clearCart();
}

@riverpod
CartActions cartActions(Ref ref) => CartActions(
  ref.watch(appDatabaseProvider),
  ref.watch(cartSyncServiceProvider),
  ref.watch(analyticsProvider),
);
