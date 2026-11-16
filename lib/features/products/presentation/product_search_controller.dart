import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/product_repository.dart';
import '../domain/product.dart';

part 'product_search_controller.g.dart';

/// Pencarian dengan debounce 400ms + pembatalan request lama.
@riverpod
Future<List<Product>> productSearch(Ref ref, String query) async {
  if (query.trim().length < 2) return const [];

  // Debounce: tunggu sebentar; jika query berubah, provider ini dibuang
  // (autoDispose) dan request tidak pernah dikirim.
  var disposed = false;
  ref.onDispose(() => disposed = true);
  await Future<void>.delayed(const Duration(milliseconds: 400));
  if (disposed) throw StateError('cancelled');

  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  final page = await ref
      .watch(productRepositoryProvider)
      .search(query, cancelToken: cancelToken);
  return page.items;
}
