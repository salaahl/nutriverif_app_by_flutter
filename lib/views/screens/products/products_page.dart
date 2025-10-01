import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';
import 'package:app_nutriverif/providers/products_provider.dart';

import '../../widgets/app_bar.dart';
import '../../widgets/loader.dart';
import '../../widgets/search_bar.dart';
import 'widgets/grid_item.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({super.key});

  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  late ProductsProvider _provider;
  late ScrollController _scrollController;

  bool _refresh = true;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();

    _provider = context.read<ProductsProvider>();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _debounceTimer?.cancel();

    _provider.clearAnimatedIds('_product');
  }

  void _onScroll() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 150), () {
      _handlePagination();
    });
  }

  void _handlePagination() async {
    if (!mounted) return;

    final scrollPos = _scrollController.position;

    if (scrollPos.pixels >= scrollPos.maxScrollExtent - 560 &&
        _provider.hasMorePages &&
        _refresh &&
        !_provider.productsIsLoading) {
      _refresh = false;
      await _provider.searchProducts(method: 'more');

      Timer(const Duration(milliseconds: 800), () {
        if (mounted) _refresh = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverPadding(
            padding: screenPadding,
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                myAppBar(context),
                const SizedBox(height: 16),
                AppSearchBar(showFilters: true),
                const SizedBox(height: 28),
              ]),
            ),
          ),

          SliverPadding(
            padding: screenPadding,
            sliver: SliverToBoxAdapter(
              child: Selector<
                ProductsProvider,
                ({bool isLoading, bool hasProducts})
              >(
                selector:
                    (_, provider) => (
                      isLoading: provider.productsIsLoading,
                      hasProducts: provider.products.isNotEmpty,
                    ),
                builder: (context, state, _) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child:
                        state.isLoading && !state.hasProducts
                            ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: _loaderWithPadding(),
                            )
                            : _buildGridView(),
                  );
                },
              ),
            ),
          ),

          Selector<ProductsProvider, ({bool isLoading, bool hasProducts})>(
            selector:
                (_, provider) => (
                  isLoading: provider.productsIsLoading,
                  hasProducts: provider.products.isNotEmpty,
                ),
            builder: (context, state, _) {
              if (state.isLoading && state.hasProducts) {
                return SliverToBoxAdapter(child: _loaderWithPadding());
              }
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
        ],
      ),
    );
  }

  Widget _loaderWithPadding() => Center(
    child: const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Loader(),
    ),
  );

  Widget _buildGridView() {
    final provider = context.read<ProductsProvider>();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 296, // productCard + spacing
      ),
      itemCount: provider.products.length,

      cacheExtent: 1000, // Pre-cache les items
      addAutomaticKeepAlives: false, // Économise la mémoire
      addRepaintBoundaries: false, // Réduit les repaints

      itemBuilder: (context, index) {
        final product = provider.products[index];

        return OptimizedProductItem(
          key: ValueKey(product.id),
          product: product,
          index: index,
        );
      },
    );
  }
}
