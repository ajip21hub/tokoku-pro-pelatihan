// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProductListController)
final productListControllerProvider = ProductListControllerProvider._();

final class ProductListControllerProvider
    extends $AsyncNotifierProvider<ProductListController, ProductListState> {
  ProductListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productListControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productListControllerHash();

  @$internal
  @override
  ProductListController create() => ProductListController();
}

String _$productListControllerHash() =>
    r'b617be3fae299ab10ed55b4c77b25897241d0d67';

abstract class _$ProductListController
    extends $AsyncNotifier<ProductListState> {
  FutureOr<ProductListState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ProductListState>, ProductListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ProductListState>, ProductListState>,
              AsyncValue<ProductListState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Detail produk per-id (family). autoDispose default di codegen.

@ProviderFor(productDetail)
final productDetailProvider = ProductDetailFamily._();

/// Detail produk per-id (family). autoDispose default di codegen.

final class ProductDetailProvider
    extends $FunctionalProvider<AsyncValue<Product>, Product, FutureOr<Product>>
    with $FutureModifier<Product>, $FutureProvider<Product> {
  /// Detail produk per-id (family). autoDispose default di codegen.
  ProductDetailProvider._({
    required ProductDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'productDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productDetailHash();

  @override
  String toString() {
    return r'productDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Product> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Product> create(Ref ref) {
    final argument = this.argument as int;
    return productDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productDetailHash() => r'982167c0d8b8070d347449bedd949b3cbf12ebd7';

/// Detail produk per-id (family). autoDispose default di codegen.

final class ProductDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Product>, int> {
  ProductDetailFamily._()
    : super(
        retry: null,
        name: r'productDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Detail produk per-id (family). autoDispose default di codegen.

  ProductDetailProvider call(int id) =>
      ProductDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'productDetailProvider';
}
