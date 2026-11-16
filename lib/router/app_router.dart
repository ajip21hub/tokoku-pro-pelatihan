import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/presentation/auth_controller.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/profile_page.dart';
import '../features/cart/presentation/cart_page.dart';
import '../features/orders/presentation/order_status_page.dart';
import '../features/products/presentation/product_detail_page.dart';
import '../features/products/presentation/product_list_page.dart';
import '../features/products/presentation/product_search_page.dart';
import 'scaffold_with_nav_bar.dart';

part 'app_router.g.dart';

abstract final class Routes {
  static const splash = '/splash';
  static const login = '/login';
  static const products = '/products';
  static const cart = '/cart';
  static const profile = '/profile';
  static String order(String id) => '/orders/$id';
}

/// Fungsi murni -> mudah di-unit-test tanpa widget.
///
/// Aturan:
/// 1. Status awal belum diketahui -> /splash, simpan tujuan di `?from=`.
///    Pengecualian: sedang di /login (proses login berjalan) -> tetap di sana
///    agar LoginPage tidak dibuang & bisa menampilkan error.
/// 2. Belum login -> `/login?from=<tujuan>`.
/// 3. Sudah login tapi di /login atau /splash -> kembali ke `from`.
/// Dengan `from`, deep link & notifikasi saat app tertutup tidak hilang.
String? authRedirect(AsyncValue<Object?> auth, Uri uri) {
  final path = uri.path;
  final atLogin = path == Routes.login;
  final atSplash = path == Routes.splash;
  final from = uri.queryParameters['from'];

  if (auth.isLoading && !auth.hasValue && !auth.hasError) {
    if (atLogin || atSplash) return null;
    return _withFrom(Routes.splash, uri.toString());
  }

  final loggedIn = auth.value != null;
  if (!loggedIn) {
    if (atLogin) return null;
    return _withFrom(Routes.login, atSplash ? from : uri.toString());
  }
  if (atLogin || atSplash) return from ?? Routes.products;
  return null;
}

String _withFrom(String path, String? from) {
  if (from == null ||
      from == Routes.products ||
      from == '/' ||
      from.startsWith(Routes.login) ||
      from.startsWith(Routes.splash)) {
    return path;
  }
  return Uri(path: path, queryParameters: {'from': from}).toString();
}

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // Jembatan Riverpod -> Listenable agar GoRouter re-evaluasi redirect
  // setiap status auth berubah, TANPA membuat ulang GoRouter.
  final authState = ValueNotifier<AsyncValue<Object?>>(const AsyncLoading());
  ref.onDispose(authState.dispose);
  ref.listen(
    authControllerProvider,
    (_, next) => authState.value = next,
    fireImmediately: true,
  );

  final router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: Routes.products,
    refreshListenable: authState,
    debugLogDiagnostics: true,
    redirect: (context, state) => authRedirect(authState.value, state.uri),
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (_, _) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      GoRoute(path: Routes.login, builder: (_, _) => const LoginPage()),
      GoRoute(
        path: '/orders/:id', // tampil di navigator root (tanpa bottom nav)
        builder: (_, state) =>
            OrderStatusPage(orderId: state.pathParameters['id']!),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => ScaffoldWithNavBar(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.products,
                builder: (_, _) => const ProductListPage(),
                routes: [
                  GoRoute(
                    path: 'search', // -> /products/search
                    parentNavigatorKey:
                        _rootKey, // tampil full-screen di atas nav bar
                    builder: (_, _) => const ProductSearchPage(),
                  ),
                  GoRoute(
                    path: ':id', // -> /products/42 (juga untuk deep link)
                    builder: (_, state) => ProductDetailPage(
                      productId: int.parse(state.pathParameters['id']!),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: Routes.cart, builder: (_, _) => const CartPage()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profile,
                builder: (_, _) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      body: Center(child: Text('Halaman tidak ditemukan: ${state.uri}')),
    ),
  );
  ref.onDispose(router.dispose);
  return router;
}
