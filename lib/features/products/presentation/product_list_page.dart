import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tokoku_core/tokoku_core.dart';

import '../../../core/error/failure.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/product.dart';
import 'product_list_controller.dart';

class ProductListPage extends ConsumerWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(productListControllerProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.catalogTitle),
        actions: [
          IconButton(
            tooltip: l10n.searchTooltip,
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/products/search'),
          ),
        ],
      ),
      body: switch (asyncState) {
        AsyncData(:final value) => RefreshIndicator(
          onRefresh: () =>
              ref.read(productListControllerProvider.notifier).refresh(),
          child: _ProductGrid(state: value),
        ),
        AsyncError(:final error) => _ErrorView(
          message: error is Failure ? error.message : '$error',
          onRetry: () => ref.invalidate(productListControllerProvider),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _ProductGrid extends ConsumerWidget {
  const _ProductGrid({required this.state});
  final ProductListState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n.metrics.extentAfter < 400) {
          ref.read(productListControllerProvider.notifier).loadMore();
        }
        return false;
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (state.fromCache)
            SliverToBoxAdapter(
              child: MaterialBanner(
                content: Text(AppLocalizations.of(context).offlineBanner),
                leading: const Icon(Icons.cloud_off),
                actions: const [SizedBox.shrink()],
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemCount: state.items.length,
              itemBuilder: (context, i) => ProductCard(product: state.items[i]),
            ),
          ),
          if (state.isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Aksesibilitas (Hari 4): pembaca layar membaca kartu sebagai SATU
    // tombol ("Nama produk, harga"), bukan tiga elemen terpisah.
    return MergeSemantics(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push('/products/${product.id}'),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Expanded(
                child: Hero(
                  tag: 'product-${product.id}',
                  child: product.thumbnail.isEmpty
                      ? const ColoredBox(
                          color: Colors.black12,
                          child: Icon(Icons.image),
                        )
                      : CachedNetworkImage(
                          imageUrl: product.thumbnail,
                          fit: .cover,
                          memCacheWidth:
                              400, // decode sesuai ukuran tampil -> hemat RAM
                          placeholder: (_, _) =>
                              const ColoredBox(color: Colors.black12),
                          errorWidget: (_, _, _) =>
                              const Icon(Icons.broken_image),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: .ellipsis,
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Money.fromDecimal(product.price, .usd).format(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: .min,
      children: [
        const Icon(Icons.error_outline, size: 48),
        const SizedBox(height: 8),
        Text(message, textAlign: .center),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: onRetry,
          child: Text(AppLocalizations.of(context).retry),
        ),
      ],
    ),
  );
}
