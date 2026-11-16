// Definisi kontrak Dart <-> native. Generate kode dengan:
//   dart run pigeon --input pigeons/device_api.dart
// Hasil: lib/core/platform/device_api.g.dart (Dart) + DeviceApi.g.kt (Kotlin).
// Implementasi Kotlin ditulis manual di MainActivity.kt.
import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/core/platform/device_api.g.dart',
    kotlinOut:
        'android/app/src/main/kotlin/id/pelatihan/tokoku_pro/DeviceApi.g.kt',
    kotlinOptions: KotlinOptions(package: 'id.pelatihan.tokoku_pro'),
  ),
)
class DeviceInfo {
  DeviceInfo({
    required this.model,
    required this.osVersion,
    required this.batteryLevel,
  });

  String model;
  String osVersion;
  int batteryLevel;
}

/// HostApi = dipanggil dari Dart, diimplementasikan di native.
@HostApi()
abstract class DeviceApi {
  DeviceInfo getDeviceInfo();
}
