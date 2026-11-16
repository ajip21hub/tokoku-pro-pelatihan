import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'device_api.g.dart';

part 'device_info_provider.g.dart';

@Riverpod(keepAlive: true)
DeviceApi deviceApi(Ref ref) => DeviceApi();

/// `null` jika platform belum mengimplementasikan API (mis. iOS di capstone
/// ini, atau widget test) -> UI cukup menyembunyikan info perangkat.
@riverpod
Future<DeviceInfo?> deviceInfo(Ref ref) async {
  try {
    return await ref.watch(deviceApiProvider).getDeviceInfo();
  } on PlatformException catch (e) {
    debugPrint('DeviceApi tidak tersedia: ${e.message}');
    return null;
  } on MissingPluginException {
    return null;
  }
}
