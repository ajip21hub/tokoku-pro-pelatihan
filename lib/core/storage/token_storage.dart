import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_storage.g.dart';

class TokenStorage {
  TokenStorage(this._storage);
  final FlutterSecureStorage _storage;

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';
  static const _userKey = 'cached_user';

  Future<String?> get accessToken => _storage.read(key: _accessKey);
  Future<String?> get refreshToken => _storage.read(key: _refreshKey);

  Future<void> save({required String access, required String refresh}) async {
    await _storage.write(key: _accessKey, value: access);
    await _storage.write(key: _refreshKey, value: refresh);
  }

  /// Profil terakhir (JSON) agar app tetap "login" saat dibuka offline.
  Future<String?> get cachedUser => _storage.read(key: _userKey);
  Future<void> saveUser(String json) =>
      _storage.write(key: _userKey, value: json);

  Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
    await _storage.delete(key: _userKey);
  }
}

@Riverpod(keepAlive: true)
TokenStorage tokenStorage(Ref ref) =>
    TokenStorage(const FlutterSecureStorage());
