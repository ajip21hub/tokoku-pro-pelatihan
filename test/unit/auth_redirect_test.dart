import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokoku_pro/router/app_router.dart';

void main() {
  const loading = AsyncLoading<Object?>();
  const loggedOut = AsyncData<Object?>(null);
  const loggedIn = AsyncData<Object?>('user');

  String? go(AsyncValue<Object?> auth, String location) =>
      authRedirect(auth, Uri.parse(location));

  test('deep link saat status belum diketahui -> splash menyimpan tujuan', () {
    expect(go(loading, '/products/5'), '/splash?from=%2Fproducts%2F5');
  });

  test('status selesai & login -> lanjut ke tujuan awal', () {
    expect(go(loggedIn, '/splash?from=%2Fproducts%2F5'), '/products/5');
  });

  test('belum login -> /login tetap membawa tujuan', () {
    expect(go(loggedOut, '/splash?from=%2Fcart'), '/login?from=%2Fcart');
    expect(go(loggedIn, '/login?from=%2Fcart'), '/cart');
  });

  test('proses login (loading) di /login -> TETAP di /login', () {
    expect(go(loading, '/login'), isNull);
  });

  test('tanpa tujuan khusus -> default ke /products', () {
    expect(go(loading, '/products'), '/splash');
    expect(go(loggedIn, '/splash'), '/products');
  });
}
