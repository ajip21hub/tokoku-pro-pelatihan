import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqlite3/common.dart';

/// Kunci enkripsi database: 32 byte acak, dibuat sekali per instalasi dan
/// disimpan di Android Keystore / iOS Keychain lewat flutter_secure_storage.
/// Jangan menaruh kunci di kode atau `--dart-define`: binary bisa dibongkar.
class DatabaseKeyStore {
  DatabaseKeyStore(this._storage, {Random? random})
    : _random = random ?? Random.secure();

  final FlutterSecureStorage _storage;
  final Random _random;
  static const _storageKey = 'db_encryption_key';

  Future<String> obtain() async {
    final existing = await _storage.read(key: _storageKey);
    if (existing != null) return existing;

    final key = [
      for (var i = 0; i < 32; i++)
        _random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ].join();
    await _storage.write(key: _storageKey, value: key);
    return key;
  }
}

final _hexKey = RegExp(r'^[0-9a-f]{64}$');

/// Dipanggil drift tepat setelah file database dibuka, sebelum query lain.
void applyEncryption(CommonDatabase db, String hexKey) {
  // Format divalidasi agar nilai kunci tidak bisa menyisipkan SQL.
  if (!_hexKey.hasMatch(hexKey)) {
    throw ArgumentError.value(
      '***',
      'hexKey',
      'harus 64 karakter heksadesimal',
    );
  }
  // Build SQLite biasa mengabaikan PRAGMA key tanpa error. Pastikan build
  // yang terpasang memang mendukung enkripsi (lihat hooks di pubspec.yaml).
  if (db.select('PRAGMA cipher').isEmpty) {
    throw StateError('SQLite tanpa dukungan enkripsi. Periksa hooks sqlite3.');
  }
  db.execute("PRAGMA key = '$hexKey'");
  // Kunci salah baru ketahuan saat halaman pertama dibaca: gagal di sini,
  // bukan di tengah query fitur.
  db.select('SELECT count(*) FROM sqlite_master');
}
