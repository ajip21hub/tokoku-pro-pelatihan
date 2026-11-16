/// Row class kustom untuk tabel CartItems (drift `@UseRowClass`).
/// Ditulis manual agar bisa dipakai sebagai tipe return provider
/// riverpod_generator (tipe hasil generate drift tidak bisa di-resolve
/// oleh generator lain pada fase build yang sama).
class CartLine {
  const CartLine({
    required this.productId,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.qty,
    required this.synced,
  });

  final int productId;
  final String title;
  final double price;
  final String thumbnail;
  final int qty;
  final bool synced;

  double get subtotal => price * qty;
}
