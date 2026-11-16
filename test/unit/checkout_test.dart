import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tokoku_pro/core/analytics/analytics_service.dart';
import 'package:tokoku_pro/core/database/app_database.dart';
import 'package:tokoku_pro/features/cart/application/checkout.dart';
import 'package:tokoku_pro/features/cart/data/cart_sync_service.dart';
import 'package:tokoku_pro/features/cart/domain/cart_line.dart';
import 'package:tokoku_pro/features/cart/presentation/cart_providers.dart';
import 'package:tokoku_pro/features/products/domain/product.dart';

/// Fake yang mencatat event: lebih mudah dibaca daripada verify() mock.
class RecordingAnalytics implements AnalyticsService {
  final events = <String>[];

  @override
  Future<void> addToCart(Product product) async =>
      events.add('add_to_cart:${product.id}');

  @override
  Future<void> beginCheckout(List<CartLine> items) async =>
      events.add('begin_checkout:${items.fold<int>(0, (n, i) => n + i.qty)}');
}

class MockSync extends Mock implements CartSyncService {}

void main() {
  late AppDatabase db;
  late RecordingAnalytics analytics;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    analytics = RecordingAnalytics();
  });
  tearDown(() => db.close());

  Future<void> addItem(int id, {int times = 1}) async {
    for (var i = 0; i < times; i++) {
      await db.addToCart(
        CartItemsCompanion.insert(
          productId: Value(id),
          title: 'P$id',
          price: 10,
          thumbnail: '',
        ),
      );
    }
  }

  test('checkout mencatat begin_checkout, mengosongkan keranjang', () async {
    await addItem(1, times: 2);
    await addItem(2);
    final checkout = Checkout(
      db,
      analytics,
      now: () => DateTime.fromMillisecondsSinceEpoch(42),
    );

    expect(await checkout(), 'ORD-42');
    expect(analytics.events, ['begin_checkout:3']);
    expect(await db.unsyncedCart(), isEmpty);
  });

  test('keranjang kosong tidak bisa checkout', () async {
    final checkout = Checkout(db, analytics);
    await expectLater(checkout(), throwsStateError);
    expect(analytics.events, isEmpty);
  });

  test('menambah ke keranjang mencatat add_to_cart', () async {
    final sync = MockSync();
    when(sync.syncNow).thenAnswer((_) async => 0);
    final actions = CartActions(db, sync, analytics);

    await actions.add(
      const Product(id: 7, title: 'Kopi', price: 3, thumbnail: ''),
    );

    expect(analytics.events, ['add_to_cart:7']);
    expect((await db.unsyncedCart()).single.productId, 7);
  });
}
