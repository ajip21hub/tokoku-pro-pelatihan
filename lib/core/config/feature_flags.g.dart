// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_flags.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(featureFlags)
final featureFlagsProvider = FeatureFlagsProvider._();

final class FeatureFlagsProvider
    extends
        $FunctionalProvider<
          AsyncValue<FeatureFlags>,
          FeatureFlags,
          FutureOr<FeatureFlags>
        >
    with $FutureModifier<FeatureFlags>, $FutureProvider<FeatureFlags> {
  FeatureFlagsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'featureFlagsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$featureFlagsHash();

  @$internal
  @override
  $FutureProviderElement<FeatureFlags> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FeatureFlags> create(Ref ref) {
    return featureFlags(ref);
  }
}

String _$featureFlagsHash() => r'2582047621434c13f0092b104d0462f9466aa1fa';
