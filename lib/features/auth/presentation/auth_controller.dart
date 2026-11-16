import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/session_events.dart';
import '../data/auth_repository.dart';
import '../domain/app_user.dart';

part 'auth_controller.g.dart';

/// Sumber kebenaran status login. `keepAlive` karena dipakai router.
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<AppUser?> build() {
    // Refresh token ditolak (lihat AuthInterceptor) -> paksa logout.
    ref.listen(sessionExpiredProvider, (_, _) => state = const AsyncData(null));
    return ref.watch(authRepositoryProvider).currentUser();
  }

  Future<void> login(String username, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).login(username, password),
    );
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(null);
  }
}
