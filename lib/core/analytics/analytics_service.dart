import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/cart/domain/cart_line.dart';
import '../../features/products/domain/product.dart';
import '../config/env.dart';

part 'analytics_service.g.dart';

/// Event e-commerce memakai nama dan parameter standar GA4, sehingga laporan
/// funnel (add_to_cart -> begin_checkout) langsung terisi tanpa konfigurasi.
/// UI dan use case hanya mengenal interface ini, bukan Firebase.
///
/// Jangan mengirim data pribadi (nama, email, alamat) sebagai parameter.
abstract interface class AnalyticsService {
  Future<void> addToCart(Product product);
  Future<void> beginCheckout(List<CartLine> items);
}

class FirebaseAnalyticsService implements AnalyticsService {
  FirebaseAnalyticsService(this._analytics);
  final FirebaseAnalytics _analytics;

  static const _currency = 'USD';

  @override
  Future<void> addToCart(Product p) => _analytics.logAddToCart(
    currency: _currency,
    value: p.price,
    items: [
      AnalyticsEventItem(
        itemId: '${p.id}',
        itemName: p.title,
        itemCategory: p.category,
        price: p.price,
        quantity: 1,
      ),
    ],
  );

  @override
  Future<void> beginCheckout(List<CartLine> items) =>
      _analytics.logBeginCheckout(
        currency: _currency,
        value: items.fold<double>(0, (sum, i) => sum + i.subtotal),
        items: [
          for (final i in items)
            AnalyticsEventItem(
              itemId: '${i.productId}',
              itemName: i.title,
              price: i.price,
              quantity: i.qty,
            ),
        ],
      );
}

/// Dipakai selama Firebase belum aktif (Hari 1–4).
class NoopAnalyticsService implements AnalyticsService {
  const NoopAnalyticsService();

  @override
  Future<void> addToCart(Product product) async {}

  @override
  Future<void> beginCheckout(List<CartLine> items) async {}
}

@Riverpod(keepAlive: true)
AnalyticsService analytics(Ref ref) => Env.enableFirebase
    ? FirebaseAnalyticsService(FirebaseAnalytics.instance)
    : const NoopAnalyticsService();
