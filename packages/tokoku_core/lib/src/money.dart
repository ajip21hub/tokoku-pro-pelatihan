/// Mata uang yang didukung. Enum dengan *primary constructor* (Dart 3.13):
/// field `symbol`, `decimals`, dst. dideklarasikan langsung di header.
enum Currency(
  final String symbol,
  final int decimals,
  final String thousandSep,
  final String decimalSep,
) {
  usd(r'$', 2, ',', '.'),
  idr('Rp', 0, '.', ','),
}

/// Nilai uang dalam satuan terkecil (sen/rupiah) memakai `int`.
///
/// Kenapa bukan `double`? `0.1 + 0.2 == 0.30000000000000004`. Untuk total
/// keranjang & pembayaran, galat pembulatan seperti itu adalah bug.
///
/// `class const Money(...)` = primary constructor konstan (Dart 3.13):
/// field `minorUnits` & `currency` + konstruktor ditulis dalam satu baris.
class const Money(final int minorUnits, final Currency currency) {
  /// Konversi dari nilai desimal API (mis. `12.99`) -> `1299` sen.
  factory Money.fromDecimal(num amount, Currency currency) =>
      Money((amount * _scale(currency)).round(), currency);

  factory Money.zero(Currency currency) => Money(0, currency);

  Money operator +(Money other) {
    _checkSameCurrency(other);
    return Money(minorUnits + other.minorUnits, currency);
  }

  Money operator *(int factor) => Money(minorUnits * factor, currency);

  bool get isZero => minorUnits == 0;

  /// `$1,299.99` atau `Rp 125.000`.
  String format() {
    final scale = _scale(currency);
    final negative = minorUnits < 0;
    final abs = minorUnits.abs();
    final whole = _group((abs ~/ scale).toString(), currency.thousandSep);
    final frac = currency.decimals == 0
        ? ''
        : '${currency.decimalSep}'
              '${(abs % scale).toString().padLeft(currency.decimals, '0')}';
    final sep = currency == .idr ? ' ' : '';
    return '${negative ? '-' : ''}${currency.symbol}$sep$whole$frac';
  }

  void _checkSameCurrency(Money other) {
    if (other.currency != currency) {
      throw ArgumentError(
        'Tidak bisa menjumlah ${other.currency} ke $currency',
      );
    }
  }

  static int _scale(Currency c) {
    var s = 1;
    for (var i = 0; i < c.decimals; i++) {
      s *= 10;
    }
    return s;
  }

  static String _group(String digits, String sep) {
    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buf.write(sep);
      buf.write(digits[i]);
    }
    return buf.toString();
  }

  @override
  bool operator ==(Object other) =>
      other is Money &&
      other.minorUnits == minorUnits &&
      other.currency == currency;

  @override
  int get hashCode => Object.hash(minorUnits, currency);

  @override
  String toString() => format();
}
