import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokoku_pro/core/network/auth_interceptor.dart';
import 'package:tokoku_pro/core/storage/token_storage.dart';

/// Penyimpanan token in-memory: berbagi state antar-request seperti aslinya,
/// sehingga skenario "request lain sudah me-refresh" bisa diuji.
class InMemoryTokenStorage extends TokenStorage {
  InMemoryTokenStorage({this.access, this.refresh})
    : super(const FlutterSecureStorage());
  String? access;
  String? refresh;
  int clears = 0;

  @override
  Future<String?> get accessToken async => access;
  @override
  Future<String?> get refreshToken async => refresh;
  @override
  Future<void> save({required String access, required String refresh}) async {
    this.access = access;
    this.refresh = refresh;
  }

  @override
  Future<void> clear() async {
    clears++;
    access = refresh = null;
  }
}

/// Adapter palsu: menggantikan HTTP sungguhan dengan respons terprogram.
class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this.handler);
  final Future<ResponseBody> Function(RequestOptions o) handler;
  final calls = <String>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions o,
    Stream<Uint8List>? _,
    Future<void>? _,
  ) {
    calls.add('${o.method} ${o.path} ${o.headers['Authorization'] ?? '-'}');
    return handler(o);
  }

  @override
  void close({bool force = false}) {}
}

Future<ResponseBody> json(int status, Object body) async =>
    ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

void main() {
  late InMemoryTokenStorage storage;
  late Dio api;
  late Dio plain;
  late FakeAdapter apiAdapter;
  var expired = 0;

  void setUpDio({
    required Future<ResponseBody> Function(RequestOptions) apiHandler,
    required Future<ResponseBody> Function(RequestOptions) plainHandler,
  }) {
    apiAdapter = FakeAdapter(apiHandler);
    api = Dio(BaseOptions(baseUrl: 'https://api.test'))
      ..httpClientAdapter = apiAdapter;
    plain = Dio(BaseOptions(baseUrl: 'https://api.test'))
      ..httpClientAdapter = FakeAdapter(plainHandler);
    api.interceptors.add(
      AuthInterceptor(
        storage: storage,
        plainDio: plain,
        onSessionExpired: () => expired++,
      ),
    );
  }

  List<String> plainCalls() => (plain.httpClientAdapter as FakeAdapter).calls;

  setUp(() {
    storage = InMemoryTokenStorage(access: 'old', refresh: 'r1');
    expired = 0;
  });

  test('401 -> refresh -> request asli diulang dengan token baru', () async {
    setUpDio(
      apiHandler: (_) => json(401, {'message': 'expired'}),
      // plainDio melayani refresh DAN retry -> bedakan berdasarkan path
      plainHandler: (o) => o.path == '/auth/refresh'
          ? json(200, {'accessToken': 'new', 'refreshToken': 'r2'})
          : json(200, {'ok': true}),
    );

    final res = await api.get<Map<String, dynamic>>('/auth/me');

    expect(res.data, {'ok': true});
    expect(apiAdapter.calls, ['GET /auth/me Bearer old']);
    expect(plainCalls(), [
      startsWith('POST /auth/refresh'),
      'GET /auth/me Bearer new',
    ]);
    expect((storage.access, storage.refresh), ('new', 'r2'));
  });

  test('3 request gagal 401 bersamaan -> refresh HANYA sekali', () async {
    setUpDio(
      apiHandler: (_) => json(401, {}),
      plainHandler: (o) => o.path == '/auth/refresh'
          ? json(200, {'accessToken': 'new', 'refreshToken': 'r2'})
          : json(200, {'path': o.path}),
    );

    final results = await Future.wait([
      api.get<Map<String, dynamic>>('/a'),
      api.get<Map<String, dynamic>>('/b'),
      api.get<Map<String, dynamic>>('/c'),
    ]);

    expect(results.map((r) => r.data!['path']), ['/a', '/b', '/c']);
    expect(
      plainCalls().where((c) => c.contains('/auth/refresh')),
      hasLength(1),
    );
  });

  test('refresh DITOLAK (403) -> token dihapus & sesi berakhir', () async {
    setUpDio(
      apiHandler: (_) => json(401, {}),
      plainHandler: (_) => json(403, {}),
    );

    await expectLater(
      api.get<dynamic>('/products'),
      throwsA(isA<DioException>()),
    );
    expect(storage.clears, 1);
    expect(expired, 1);
  });

  test('jaringan putus saat refresh -> user TIDAK di-logout', () async {
    setUpDio(
      apiHandler: (_) => json(401, {}),
      plainHandler: (o) => throw DioException(
        requestOptions: o,
        type: DioExceptionType.connectionError,
      ),
    );

    await expectLater(
      api.get<dynamic>('/products'),
      throwsA(isA<DioException>()),
    );
    expect(storage.clears, 0);
    expect(storage.access, 'old');
    expect(expired, 0);
  });

  test('respons refresh rusak -> error, BUKAN hang', () async {
    setUpDio(
      apiHandler: (_) => json(401, {}),
      plainHandler: (_) => json(200, {'unexpected': true}), // tanpa token
    );

    await expectLater(
      api.get<dynamic>('/products').timeout(const Duration(seconds: 2)),
      throwsA(isA<DioException>()),
    );
  });
}
