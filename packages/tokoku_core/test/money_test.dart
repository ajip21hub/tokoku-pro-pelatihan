import 'package:flutter_test/flutter_test.dart';
import 'package:tokoku_core/tokoku_core.dart';

void main() {
  test('fromDecimal menghindari galat floating point', () {
    final total = Money.fromDecimal(0.1, .usd) + Money.fromDecimal(0.2, .usd);
    expect(total, Money.fromDecimal(0.3, .usd));
  });

  test('format USD dengan pemisah ribuan', () {
    expect(Money.fromDecimal(1299.99, .usd).format(), r'$1,299.99');
    expect(Money.fromDecimal(7.5, .usd).format(), r'$7.50');
  });

  test('format Rupiah tanpa desimal', () {
    expect(const Money(125000, .idr).format(), 'Rp 125.000');
  });

  test('perkalian qty & penjumlahan', () {
    final subtotal = Money.fromDecimal(9.99, .usd) * 3;
    expect(subtotal.format(), r'$29.97');
  });

  test('beda mata uang -> ArgumentError', () {
    expect(
      () => Money.zero(.usd) + Money.zero(.idr),
      throwsA(isA<ArgumentError>()),
    );
  });
}
