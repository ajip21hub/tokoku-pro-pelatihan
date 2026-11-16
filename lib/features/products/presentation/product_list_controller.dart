import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/product_repository.dart';
import '../domain/product.dart';

part 'product_list_controller.freezed.dart';
part 'product_list_controller.g.dart';

@freezed
abstract class ProductListState with _$ProductListState {
  const ProductListState._();
  const factory ProductListState({
    @Default([]) List<Product> items,
    @Default(0) int total,
    @Default(false) bool isLoadingMore,
    @Default(false) bool fromCache,
  }) = _ProductListState;

  bool get hasMore => items.length < total;
}

@riverpod
class ProductListController extends _$ProductListController {
  static const pageSize = 20;

  @override
  Future<ProductListState> build() async {
    final cancelToken = CancelToken();
    ref.onDispose(cancelToken.cancel); // batalkan request jika provider dibuang
    final page = await ref
        .watch(productRepositoryProvider)
        .getPage(limit: pageSize, skip: 0, cancelToken: cancelToken);
    return ProductListState(
      items: page.items,
      total: page.total,
      fromCache: page.fromCache,
    );
  }

  /// Infinite scroll: dipanggil saat user mendekati akhir list.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final page = await ref
          .read(productRepositoryProvider)
          .getPage(limit: pageSize, skip: current.items.length);
      if (!ref.mounted) return; // Riverpod 3: cek provider masih hidup
      state = AsyncData(
        current.copyWith(
          items: [...current.items, ...page.items],
          total: page.total,
          isLoadingMore: false,
          fromCache: page.fromCache,
        ),
      );
    } catch (_) {
      if (!ref.mounted) return;
      // Jangan buang data lama; cukup hentikan indikator loading.
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }

  /// Pull-to-refresh.
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

/// Detail produk per-id (family). autoDispose default di codegen.
@riverpod
Future<Product> productDetail(Ref ref, int id) =>
    ref.watch(productRepositoryProvider).detail(id);
