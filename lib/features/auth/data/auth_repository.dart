import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/failure.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/storage/token_storage.dart';
import '../domain/app_user.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._dio, this._storage);
  final Dio _dio;
  final TokenStorage _storage;

  Future<AppUser> login(String username, String password) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'username': username, 'password': password, 'expiresInMins': 30},
      );
      final data = res.data!;
      await _storage.save(
        access: data['accessToken'] as String,
        refresh: data['refreshToken'] as String,
      );
      final user = AppUser.fromJson(data);
      await _storage.saveUser(jsonEncode(user.toJson()));
      return user;
    } catch (e) {
      throw mapDioError(e);
    }
  }

  /// User jika token masih valid, `null` jika belum login.
  /// Offline-first: jika jaringan putus, pakai profil tersimpan agar user
  /// tidak "ter-logout" hanya karena sedang di pesawat.
  Future<AppUser?> currentUser() async {
    if (await _storage.accessToken == null) return null;
    try {
      final res = await _dio.get<Map<String, dynamic>>('/auth/me');
      final user = AppUser.fromJson(res.data!);
      await _storage.saveUser(jsonEncode(user.toJson()));
      return user;
    } catch (e) {
      final failure = mapDioError(e);
      if (failure is UnauthorizedFailure) {
        await _storage.clear();
        return null;
      }
      if (failure is NetworkFailure) {
        final cached = await _storage.cachedUser;
        if (cached != null) {
          return AppUser.fromJson(jsonDecode(cached) as Map<String, dynamic>);
        }
      }
      throw failure;
    }
  }

  Future<void> logout() => _storage.clear();
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepository(ref.watch(dioProvider), ref.watch(tokenStorageProvider));
