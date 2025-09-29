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

  // Optimisation : Réutilisation des notifiers + nettoyage automatique
  final Map<String, ValueNotifier<bool>> _animatedNotifiers = {};
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
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _debounceTimer?.cancel();

    for (var notifier in _animatedNotifiers.values) {
      notifier.dispose();
    }
    _animatedNotifiers.clear();
    super.dispose();
  }

  void resetAnimatedProducts() {
    _animatedNotifiers.forEach((key, notifier) {
      notifier.value = false;
    });
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

    if (scrollPos.pixels >= scrollPos.maxScrollExtent - 440 &&
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
    _provider = context.watch<ProductsProvider>();

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
                AppSearchBar(showFilters: true, onReset: resetAnimatedProducts),
                const SizedBox(height: 28),
              ]),
            ),
          ),

          if (_provider.products.isNotEmpty)
            SliverPadding(
              padding: screenPadding,
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _buildGridView(),
                ),
              ),
            ),

          if (_provider.productsIsLoading)
            const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Loader(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
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
      itemCount: _provider.products.length,

      cacheExtent: 1000, // Pre-cache les items
      addAutomaticKeepAlives: false, // Économise la mémoire
      addRepaintBoundaries: false, // Réduit les repaints

      itemBuilder: (context, index) {
        final product = _provider.products[index];

        return OptimizedProductItem(
          key: ValueKey(product.id),
          product: product,
          index: index,
          notifier: _getOrCreateNotifier(product.id),
        );
      },
    );
  }

  ValueNotifier<bool> _getOrCreateNotifier(String productId) {
    return _animatedNotifiers.putIfAbsent(
      productId,
      () => ValueNotifier<bool>(false),
    );
  }
}
