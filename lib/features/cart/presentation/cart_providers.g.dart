// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stream reaktif dari drift: UI otomatis update saat tabel berubah.

@ProviderFor(cartItems)
final cartItemsProvider = CartItemsProvider._();

/// Stream reaktif dari drift: UI otomatis update saat tabel berubah.

final class CartItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CartLine>>,
          List<CartLine>,
          Stream<List<CartLine>>
        >
    with $FutureModifier<List<CartLine>>, $StreamProvider<List<CartLine>> {
  /// Stream reaktif dari drift: UI otomatis update saat tabel berubah.
  CartItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartItemsHash();

  @$internal
  @override
  $StreamProviderElement<List<CartLine>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CartLine>> create(Ref ref) {
    return cartItems(ref);
  }
}

String _$cartItemsHash() => r'1a5c569b1497680a2362b51b8b0ab9e48e50005f';

/// Derived state: jumlah item & total (pakai `Money`, bukan double).

@ProviderFor(cartSummary)
final cartSummaryProvider = CartSummaryProvider._();

/// Derived state: jumlah item & total (pakai `Money`, bukan double).

final class CartSummaryProvider
    extends
        $FunctionalProvider<
          ({int count, Money total}),
          ({int count, Money total}),
          ({int count, Money total})
        >
    with $Provider<({int count, Money total})> {
  /// Derived state: jumlah item & total (pakai `Money`, bukan double).
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

String _$cartSummaryHash() => r'cd9d3dd95a5e6028ad55299f5b180c13db6b22e9';

@ProviderFor(cartActions)
final cartActionsProvider = CartActionsProvider._();

final class CartActionsProvider
    extends $FunctionalProvider<CartActions, CartActions, CartActions>
    with $Provider<CartActions> {
  CartActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartActionsHash();

  @$internal
  @override
  $ProviderElement<CartActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CartActions create(Ref ref) {
    return cartActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CartActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CartActions>(value),
    );
  }
}

String _$cartActionsHash() => r'c802aa9e3975fe1a054e195c7985ca3c0cb29ba1';
