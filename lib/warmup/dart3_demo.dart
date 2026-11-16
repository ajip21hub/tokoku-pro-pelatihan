// ignore_for_file: avoid_print
// Dart 3.0 -> 3.13: fitur yang dipakai sepanjang pelatihan.

// 1) PRIMARY CONSTRUCTORS (stable Dart 3.13).
//    Sebelumnya:
//      final class Paid extends PaymentStatus {
//        const Paid(this.amount);
//        final double amount;
//      }
//    Sekarang field + konstruktor cukup di header class:
sealed class PaymentStatus {
  const PaymentStatus();
}

final class const Paid(final double amount) extends PaymentStatus;

final class const Pending() extends PaymentStatus;

final class const Failed(final String reason, {final bool retryable = false})
    extends PaymentStatus;

// 2) SEALED + SWITCH EXPRESSION exhaustive (Dart 3.0).
String describe(PaymentStatus s) => switch (s) {
  Paid(:final amount) when amount > 100 => 'Lunas (besar): \$$amount',
  Paid(:final amount) => 'Lunas: \$$amount',
  Pending() => 'Menunggu pembayaran',
  Failed(:final reason, retryable: true) => 'Gagal ($reason), coba lagi',
  Failed(:final reason) => 'Gagal: $reason',
  // Tidak perlu `default`: compiler tahu semua subtype sudah ditangani.
};

// 3) DOT SHORTHANDS (Dart 3.10): nama tipe boleh dihilangkan bila konteks
//    tipenya sudah jelas -> `.pending` bukan `Priority.pending`.
enum Priority { low, normal, high }

Priority parsePriority(String raw) => switch (raw) {
  'urgent' => .high,
  'later' => .low,
  _ => .normal,
};

// 4) RECORDS + destructuring (Dart 3.0).
(int count, double total) summarize(List<double> prices) =>
    (prices.length, prices.fold(0.0, (a, b) => a + b));

// 5) PATTERN MATCHING pada JSON: aman tanpa cast manual.
String? cityFromJson(Map<String, dynamic> json) {
  if (json case {'address': {'city': final String city}}) return city;
  return null;
}

void main() {
  final (count, total) = summarize([10, 20.5]);
  print('$count item, total $total');
  print(describe(const Paid(150)));
  print(describe(const Failed('timeout', retryable: true)));
  print(parsePriority('urgent'));
  print(
    cityFromJson({
      'address': {'city': 'Yogyakarta'},
    }),
  );
}
