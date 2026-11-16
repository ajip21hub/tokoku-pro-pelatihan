// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_status_socket.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(orderStatusSocket)
final orderStatusSocketProvider = OrderStatusSocketProvider._();

final class OrderStatusSocketProvider
    extends
        $FunctionalProvider<
          OrderStatusSocket,
          OrderStatusSocket,
          OrderStatusSocket
        >
    with $Provider<OrderStatusSocket> {
  OrderStatusSocketProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderStatusSocketProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderStatusSocketHash();

  @$internal
  @override
  $ProviderElement<OrderStatusSocket> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OrderStatusSocket create(Ref ref) {
    return orderStatusSocket(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderStatusSocket value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderStatusSocket>(value),
    );
  }
}

String _$orderStatusSocketHash() => r'c9272bcb8ceb76e62ede83d0c0dbb688f0967b35';

/// autoDispose: keluar dari halaman -> subscription dibatalkan -> socket ditutup.

@ProviderFor(orderStatus)
final orderStatusProvider = OrderStatusFamily._();

/// autoDispose: keluar dari halaman -> subscription dibatalkan -> socket ditutup.

final class OrderStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<OrderStatus>,
          OrderStatus,
          Stream<OrderStatus>
        >
    with $FutureModifier<OrderStatus>, $StreamProvider<OrderStatus> {
  /// autoDispose: keluar dari halaman -> subscription dibatalkan -> socket ditutup.
  OrderStatusProvider._({
    required OrderStatusFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'orderStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$orderStatusHash();

  @override
  String toString() {
    return r'orderStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<OrderStatus> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<OrderStatus> create(Ref ref) {
    final argument = this.argument as String;
    return orderStatus(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orderStatusHash() => r'653f01f5737524fe5b743f5fe5f6ab566c18bdd7';

/// autoDispose: keluar dari halaman -> subscription dibatalkan -> socket ditutup.

final class OrderStatusFamily extends $Family
    with $FunctionalFamilyOverride<Stream<OrderStatus>, String> {
  OrderStatusFamily._()
    : super(
        retry: null,
        name: r'orderStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// autoDispose: keluar dari halaman -> subscription dibatalkan -> socket ditutup.

  OrderStatusProvider call(String orderId) =>
      OrderStatusProvider._(argument: orderId, from: this);

  @override
  String toString() => r'orderStatusProvider';
}
