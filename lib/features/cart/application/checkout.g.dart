// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(checkout)
final checkoutProvider = CheckoutProvider._();

final class CheckoutProvider
    extends $FunctionalProvider<Checkout, Checkout, Checkout>
    with $Provider<Checkout> {
  CheckoutProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkoutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkoutHash();

  @$internal
  @override
  $ProviderElement<Checkout> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Checkout create(Ref ref) {
    return checkout(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Checkout value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Checkout>(value),
    );
  }
}

String _$checkoutHash() => r'1be1c367640ac534d3ed34d31abe6e5ecbfe747f';
