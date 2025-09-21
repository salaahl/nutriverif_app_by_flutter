import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

import 'package:app_nutriverif/providers/products_provider.dart';

import '../widgets/app_bar.dart';
import '../widgets/loader.dart';
import '../widgets/search_bar.dart';
import '../widgets/product_card/product_card.dart';

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
            padding: screenPadding,
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
                AnimatedSize(
                  duration: defaultAnimationTime * 2,
                  curve: defaultAnimationCurve,
                  child: Container(
                    height:
                        _provider.productsIsLoading &&
                                _provider.products.isEmpty
                            ? 0
                            : null,
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Colonnes
                            crossAxisSpacing: 16, // Espacement horizontal
                            mainAxisSpacing: 16, // Espacement vertical
                            /* 
                            * Hauteur de la carte redéfinie (car pas pris en compte)
                            * 280 = hauteur de la carte d'un produit
                            * 16 = prise en compte de l'espace entre chaque carte
                            */
                            mainAxisExtent: 296,
                          ),
                      padding: EdgeInsets.only(top: 16),
                      itemCount: _provider.products.length,
                      itemBuilder: (context, index) {
                        final product = _provider.products[index];
                        final productCard = ProductCard(
                          product: product,
                          widthAjustment: 32,
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
                                    tween: Tween(
                                      begin: 0.0,
                                      end: alreadyAnimated ? 1.0 : 0.0,
                                    ),
                                    duration: Duration(milliseconds: 350),
                                    curve: Curves.easeInOut,
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
                  ),
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
