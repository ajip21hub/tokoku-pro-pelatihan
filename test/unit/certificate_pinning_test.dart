import 'package:flutter_test/flutter_test.dart';
import 'package:tokoku_pro/core/network/certificate_pinning.dart';

void main() {
  test('parsePins menormalkan format openssl (huruf besar, titik dua)', () {
    expect(parsePins(' AB:CD:01 , ,ef02 '), {'abcd01', 'ef02'});
    expect(parsePins(''), isEmpty);
  });

  test('sha256Fingerprint konsisten dengan openssl dgst -sha256', () {
    // echo -n "abc" | openssl dgst -sha256
    expect(
      sha256Fingerprint('abc'.codeUnits),
      'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',
    );
  });

  test('tanpa pin -> pakai adapter default (pinning nonaktif)', () {
    expect(pinnedHttpClientAdapter(const {}), isNull);
    expect(pinnedHttpClientAdapter(const {'ab'}), isNotNull);
  });
}
