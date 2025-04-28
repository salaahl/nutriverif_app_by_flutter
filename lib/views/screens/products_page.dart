import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/app_bar.dart';
import '../widgets/loader.dart';
import '../widgets/search_bar.dart';
import '../widgets/product_card.dart';
import 'package:provider/provider.dart';
import 'package:app_nutriverif/providers/products_provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({super.key});

  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  late ProductsProvider _provider;

  final ScrollController _scrollController = ScrollController();
  final Set<String> _animatedProductIds = {};

  @override
  void initState() {
    super.initState();

    _provider = context.read<ProductsProvider>();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _refresh = true;

  void _onScroll() async {
    final scrollPos = _scrollController.position;

    // 440 = hauteur de la carte d'un produit et demi
    if (scrollPos.pixels >= scrollPos.maxScrollExtent - 440 &&
        _provider.hasMorePages &&
        _refresh) {
      _refresh = false;
      await _provider.searchProducts(method: 'more');
      Timer(Duration(milliseconds: 1500), () => _refresh = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    _provider = context.watch<ProductsProvider>();

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                myAppBar(context),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [AppSearchBar(showFilters: true)],
                  ),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.55,
                  ),
                  itemCount: _provider.products.length,
                  itemBuilder: (context, index) {
                    final product = _provider.products[index];
                    final productCard = ProductCard(
                      product: product,
                      widthAjustment: 16,
                      heroTransition: true,
                    );

                    final alreadyAnimated = _animatedProductIds.contains(
                      product.id,
                    );

                    return VisibilityDetector(
                      key: Key(product.id),
                      onVisibilityChanged: (info) {
                        if (info.visibleFraction >= 0.20 &&
                            !_animatedProductIds.contains(product.id)) {
                          setState(() {
                            _animatedProductIds.add(product.id);
                          });
                        }
                      },
                      child:
                          alreadyAnimated
                              ? TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.0, end: 1.0),
                                duration: const Duration(milliseconds: 250),
                                builder: (context, value, child) {
                                  return Opacity(
                                    opacity: value,
                                    child: Transform.translate(
                                      offset: Offset(0, 35 * (1 - value)),
                                      child: child,
                                    ),
                                  );
                                },
                                child: productCard,
                              )
                              : const SizedBox(
                                height: 280,
                                width: double.infinity,
                              ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                if (_provider.productsIsLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 32),
                      child: Loader(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
