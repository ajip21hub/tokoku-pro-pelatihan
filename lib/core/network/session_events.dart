import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_events.g.dart';

/// "Bel" sesi berakhir. Dio (lapisan core) membunyikannya, AuthController
/// (fitur auth) mendengarkannya. Dengan begitu `core/` tidak perlu meng-import
/// fitur auth -> tidak ada dependensi melingkar.
@Riverpod(keepAlive: true)
class SessionExpired extends _$SessionExpired {
  @override
  int build() => 0;

  void notify() => state++;
}
