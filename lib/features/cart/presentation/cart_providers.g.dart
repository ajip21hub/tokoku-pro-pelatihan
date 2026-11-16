// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cartSummary)
final cartSummaryProvider = CartSummaryProvider._();

final class CartSummaryProvider
    extends
        $FunctionalProvider<
          ({int count, Money total}),
          ({int count, Money total}),
          ({int count, Money total})
        >
    with $Provider<({int count, Money total})> {
  CartSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartSummaryHash();

  @$internal
  @override
  $ProviderElement<({int count, Money total})> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ({int count, Money total}) create(Ref ref) {
    return cartSummary(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(({int count, Money total}) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<({int count, Money total})>(value),
    );
  }
}

String _$cartSummaryHash() => r'439358649a3324d36a5eab34e1b61d7c04eab56a';
