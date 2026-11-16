import 'dart:convert';

/// Status pesanan. Enum + primary constructor (Dart 3.13).
enum OrderStatus(final String label, final bool isFinal) {
  created('Pesanan dibuat', false),
  processing('Sedang diproses', false),
  shipped('Dalam pengiriman', false),
  delivered('Pesanan sampai', true);

  /// Pesan dari server: `{"orderId":"ORD-1","status":"shipped"}`.
  /// Pattern matching pada Map (Dart 3) = parsing JSON yang aman tanpa cast.
  static OrderStatus? tryParse(String message) {
    final Object? json;
    try {
      json = jsonDecode(message);
    } on FormatException {
      return null;
    }
    if (json case {'status': final String name}) {
      return values.asNameMap()[name];
    }
    return null;
  }
}
