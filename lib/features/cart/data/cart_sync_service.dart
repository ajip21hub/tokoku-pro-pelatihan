import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/app_database.dart';
import '../../../core/network/dio_client.dart';

part 'cart_sync_service.g.dart';

/// Status koneksi sebagai stream. connectivity_plus hanya tahu ada
/// interface jaringan, BUKAN pasti ada internet -> tetap tangani error.
@Riverpod(keepAlive: true)
Stream<bool> isOnline(Ref ref) => Connectivity().onConnectivityChanged
    .map((r) => !r.contains(ConnectivityResult.none))
    .distinct();

/// Outbox pattern: kirim item keranjang yang belum tersinkron.
/// Dipicu oleh: (1) item ditambah, (2) kembali online,
/// (3) workmanager di background walau app ditutup (lihat background_sync.dart).
class CartSyncService {
  CartSyncService(this._db, this._dio);
  final AppDatabase _db;
  final Dio _dio;

  bool _running = false;
  bool _runAgain = false;

  /// Mengembalikan jumlah item yang berhasil ditandai tersinkron.
  Future<int> syncNow({int userId = 1}) async {
    if (_running) {
      // Jangan dobel kirim; cukup tandai agar diulang setelah putaran ini.
      _runAgain = true;
      return 0;
    }
    _running = true;
    var synced = 0;
    try {
      do {
        _runAgain = false;
        synced += await _syncOnce(userId);
      } while (_runAgain);
      return synced;
    } finally {
      _running = false;
    }
  }

  Future<int> _syncOnce(int userId) async {
    final pending = await _db.unsyncedCart();
    if (pending.isEmpty) return 0;
    try {
      await _dio.post<Map<String, dynamic>>(
        '/carts/add',
        data: {
          'userId': userId,
          'products': [
            for (final i in pending) {'id': i.productId, 'quantity': i.qty},
          ],
        },
      );
    } on DioException catch (e) {
      debugPrint('Sync gagal, akan dicoba lagi: ${e.message}');
      return 0;
    }
    return _db.markSynced({for (final i in pending) i.productId: i.qty});
  }
}

@Riverpod(keepAlive: true)
CartSyncService cartSyncService(Ref ref) {
  final service = CartSyncService(
    ref.watch(appDatabaseProvider),
    ref.watch(dioProvider),
  );
  // Setiap transisi offline -> online, jalankan sync.
  ref.listen(isOnlineProvider, (prev, next) {
    if (next.value == true && prev?.value != true) unawaited(service.syncNow());
  });
  return service;
}
