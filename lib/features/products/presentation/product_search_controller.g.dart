// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_search_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Pencarian dengan debounce 400ms + pembatalan request lama.

@ProviderFor(productSearch)
final productSearchProvider = ProductSearchFamily._();

/// Pencarian dengan debounce 400ms + pembatalan request lama.

final class ProductSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          FutureOr<List<Product>>
        >
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
  /// Pencarian dengan debounce 400ms + pembatalan request lama.
  ProductSearchProvider._({
    required ProductSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productSearchHash();

  @override
  String toString() {
    return r'productSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Product>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Product>> create(Ref ref) {
    final argument = this.argument as String;
    return productSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productSearchHash() => r'0e03a34c68cc0c3c5b7e7f484245cd285dd39ee9';

/// Pencarian dengan debounce 400ms + pembatalan request lama.

final class ProductSearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Product>>, String> {
  ProductSearchFamily._()
    : super(
        retry: null,
        name: r'productSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Pencarian dengan debounce 400ms + pembatalan request lama.

  ProductSearchProvider call(String query) =>
      ProductSearchProvider._(argument: query, from: this);

  @override
  String toString() => r'productSearchProvider';
}
