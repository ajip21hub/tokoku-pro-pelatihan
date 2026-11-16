// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Status koneksi sebagai stream. connectivity_plus hanya tahu ada
/// interface jaringan, BUKAN pasti ada internet -> tetap tangani error.

@ProviderFor(isOnline)
final isOnlineProvider = IsOnlineProvider._();

/// Status koneksi sebagai stream. connectivity_plus hanya tahu ada
/// interface jaringan, BUKAN pasti ada internet -> tetap tangani error.

final class IsOnlineProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// Status koneksi sebagai stream. connectivity_plus hanya tahu ada
  /// interface jaringan, BUKAN pasti ada internet -> tetap tangani error.
  IsOnlineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isOnlineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isOnlineHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return isOnline(ref);
  }
}

String _$isOnlineHash() => r'a38bcc27105270675392a332779fad445202871f';

@ProviderFor(cartSyncService)
final cartSyncServiceProvider = CartSyncServiceProvider._();

final class CartSyncServiceProvider
    extends
        $FunctionalProvider<CartSyncService, CartSyncService, CartSyncService>
    with $Provider<CartSyncService> {
  CartSyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartSyncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartSyncServiceHash();

  @$internal
  @override
  $ProviderElement<CartSyncService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CartSyncService create(Ref ref) {
    return cartSyncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CartSyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CartSyncService>(value),
    );
  }
}

String _$cartSyncServiceHash() => r'd5d188be3920b324dd26c4a7ca5f2857fd1578db';
