// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(deviceApi)
final deviceApiProvider = DeviceApiProvider._();

final class DeviceApiProvider
    extends $FunctionalProvider<DeviceApi, DeviceApi, DeviceApi>
    with $Provider<DeviceApi> {
  DeviceApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceApiHash();

  @$internal
  @override
  $ProviderElement<DeviceApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeviceApi create(Ref ref) {
    return deviceApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceApi>(value),
    );
  }
}

String _$deviceApiHash() => r'a41566e4b8975c36d73538bb04e0b5c5ed320c0c';

/// `null` jika platform belum mengimplementasikan API (mis. iOS di capstone
/// ini, atau widget test) -> UI cukup menyembunyikan info perangkat.

@ProviderFor(deviceInfo)
final deviceInfoProvider = DeviceInfoProvider._();

/// `null` jika platform belum mengimplementasikan API (mis. iOS di capstone
/// ini, atau widget test) -> UI cukup menyembunyikan info perangkat.

final class DeviceInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<DeviceInfo?>,
          DeviceInfo?,
          FutureOr<DeviceInfo?>
        >
    with $FutureModifier<DeviceInfo?>, $FutureProvider<DeviceInfo?> {
  /// `null` jika platform belum mengimplementasikan API (mis. iOS di capstone
  /// ini, atau widget test) -> UI cukup menyembunyikan info perangkat.
  DeviceInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceInfoHash();

  @$internal
  @override
  $FutureProviderElement<DeviceInfo?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DeviceInfo?> create(Ref ref) {
    return deviceInfo(ref);
  }
}

String _$deviceInfoHash() => r'f7455d4354c8bebcd8937a5f26b3d1c4c92d1d35';
