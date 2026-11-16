import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokoku_pro/app.dart';
import 'package:tokoku_pro/core/database/app_database.dart';
import 'package:tokoku_pro/core/settings/theme_mode_controller.dart';
import 'package:tokoku_pro/features/auth/domain/app_user.dart';
import 'package:tokoku_pro/features/auth/presentation/auth_controller.dart';
import 'package:tokoku_pro/features/auth/presentation/login_page.dart';
import 'package:tokoku_pro/features/cart/data/cart_sync_service.dart';
import 'package:tokoku_pro/router/app_router.dart';
import 'package:tokoku_pro/warmup/language_controller.dart';

/// Fake controller: kita kendalikan status login secara manual.
class FakeAuthController extends AuthController {
  @override
  Future<AppUser?> build() async => null;

  @override
  Future<void> login(String username, String password) async {
    state = const AsyncData(
      AppUser(
        id: 1,
        username: 'emilys',
        email: 'e@x.com',
        firstName: 'Emily',
        lastName: 'J',
      ),
    );
  }
}

class FakeThemeMode extends ThemeModeController {
  @override
  Future<ThemeMode> build() async => ThemeMode.light;
}

void main() {
  testWidgets(
    'deep link /cart saat belum login -> login -> mendarat di /cart',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      final container = ProviderContainer.test(
        overrides: [
          authControllerProvider.overrideWith(FakeAuthController.new),
          themeModeControllerProvider.overrideWith(FakeThemeMode.new),
          appDatabaseProvider.overrideWithValue(db),
          isOnlineProvider.overrideWith((ref) => Stream.value(false)),
          currentLocaleProvider.overrideWithValue(const Locale('id')),
        ],
        retry: (_, _) => null,
      );
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const TokoKuApp(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);

      // Seperti deep link tokoku://app/cart saat user belum login.
      container.read(appRouterProvider).go('/cart');
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);

      await tester.tap(find.byKey(const Key('login-button')));
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsNothing);
      expect(find.text('Keranjang masih kosong'), findsOneWidget);

      // Bersihkan stream drift sebelum test selesai
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 10));
    },
  );
}
