import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' show sqlite3;
import 'package:tokoku_pro/core/database/app_database.dart';
import 'package:tokoku_pro/core/database/database_key.dart';

void main() {
  group('DatabaseKeyStore', () {
    setUp(() => FlutterSecureStorage.setMockInitialValues({}));

    test('membuat kunci 256-bit sekali, lalu memakai ulang', () async {
      final store = DatabaseKeyStore(const FlutterSecureStorage());
      final first = await store.obtain();
      final second = await store.obtain();

      expect(first, matches(RegExp(r'^[0-9a-f]{64}$')));
      expect(second, first);
    });
  });

  group('file database terenkripsi', () {
    late Directory dir;
    late File file;
    final key = 'a1' * 32;

    setUp(() {
      dir = Directory.systemTemp.createTempSync('tokoku_db');
      file = File('${dir.path}/tokoku.sqlite');
    });
    tearDown(() => dir.deleteSync(recursive: true));

    AppDatabase open(String k) => AppDatabase(
      NativeDatabase(file, setup: (db) => applyEncryption(db, k)),
    );

    Future<void> seed() async {
      final db = open(key);
      await db.addToCart(
        CartItemsCompanion.insert(
          productId: const Value(1),
          title: 'Rahasia',
          price: 10,
          thumbnail: '',
        ),
      );
      await db.close();
    }

    test('isi file tidak bisa dibaca tanpa kunci', () async {
      await seed();
      final bytes = file.readAsBytesSync();
      // File SQLite biasa selalu diawali "SQLite format 3".
      expect(String.fromCharCodes(bytes.take(15)), isNot('SQLite format 3'));
      expect(String.fromCharCodes(bytes).contains('Rahasia'), isFalse);
    });

    test('kunci benar membuka data, kunci salah ditolak', () async {
      await seed();

      final ok = open(key);
      expect((await ok.unsyncedCart()).single.title, 'Rahasia');
      await ok.close();

      final wrong = open('b2' * 32);
      await expectLater(wrong.unsyncedCart(), throwsA(isA<Object>()));
      await wrong.close();
    });

    test('kunci yang bukan heksadesimal ditolak sebelum dipakai', () {
      final db = sqlite3.openInMemory();
      addTearDown(db.close);
      expect(
        () => applyEncryption(db, "x'; DROP TABLE cart_items; --"),
        throwsArgumentError,
      );
    });
  });
}
