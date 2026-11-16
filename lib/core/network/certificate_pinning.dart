import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

/// Certificate pinning: hanya percaya sertifikat server yang sidik jarinya
/// (SHA-256 dari DER) ada di daftar. Melindungi dari serangan MITM walau
/// perangkat memasang CA palsu (mis. proxy kantor/attacker).
///
/// Ambil sidik jari sertifikat saat ini:
/// ```sh
/// openssl s_client -connect dummyjson.com:443 -servername dummyjson.com \
///   </dev/null 2>/dev/null | openssl x509 -outform DER | openssl dgst -sha256
/// ```
///
/// PENTING: sertifikat diperbarui berkala. SELALU pasang minimal 2 pin (aktif +
/// cadangan) dan rencanakan rotasi, atau app lama tidak bisa konek sama sekali.
Set<String> parsePins(String raw) => raw
    .split(',')
    .map((p) => p.trim().toLowerCase().replaceAll(':', ''))
    .where((p) => p.isNotEmpty)
    .toSet();

String sha256Fingerprint(List<int> der) => sha256.convert(der).toString();

bool isPinned(X509Certificate? cert, Set<String> pins) =>
    cert != null && pins.contains(sha256Fingerprint(cert.der));

/// Adapter Dio yang menolak koneksi jika sertifikat tidak cocok.
/// Mengembalikan `null` (pakai adapter default) bila daftar pin kosong.
HttpClientAdapter? pinnedHttpClientAdapter(Set<String> pins) {
  if (pins.isEmpty) return null;
  return IOHttpClientAdapter(
    validateCertificate: (cert, host, port) => isPinned(cert, pins),
  );
}
