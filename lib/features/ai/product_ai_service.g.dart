// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_ai_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(productAiService)
final productAiServiceProvider = ProductAiServiceProvider._();

final class ProductAiServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProductAiService?>,
          ProductAiService?,
          FutureOr<ProductAiService?>
        >
    with
        $FutureModifier<ProductAiService?>,
        $FutureProvider<ProductAiService?> {
  ProductAiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productAiServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productAiServiceHash();

  @$internal
  @override
  $FutureProviderElement<ProductAiService?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProductAiService?> create(Ref ref) {
    return productAiService(ref);
  }
}

String _$productAiServiceHash() => r'21981c48b1e8a6959b470055a2b7c5d0006b3bdc';

/// `null` = fitur nonaktif (UI menyembunyikan kartu AI).

@ProviderFor(productAiSummary)
final productAiSummaryProvider = ProductAiSummaryFamily._();

/// `null` = fitur nonaktif (UI menyembunyikan kartu AI).

final class ProductAiSummaryProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// `null` = fitur nonaktif (UI menyembunyikan kartu AI).
  ProductAiSummaryProvider._({
    required ProductAiSummaryFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'productAiSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productAiSummaryHash();

  @override
  String toString() {
    return r'productAiSummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    final argument = this.argument as int;
    return productAiSummary(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductAiSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productAiSummaryHash() => r'd658de7f0df83c26e788fcb5ba9e80c6a2ea47c3';

/// `null` = fitur nonaktif (UI menyembunyikan kartu AI).

final class ProductAiSummaryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String?>, int> {
  ProductAiSummaryFamily._()
    : super(
        retry: null,
        name: r'productAiSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// `null` = fitur nonaktif (UI menyembunyikan kartu AI).

  ProductAiSummaryProvider call(int productId) =>
      ProductAiSummaryProvider._(argument: productId, from: this);

  @override
  String toString() => r'productAiSummaryProvider';
}
