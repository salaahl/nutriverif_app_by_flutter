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
  late ProductsProvider provider = Provider.of<ProductsProvider>(context);

  double _prevScrollPos = 0;
  double searchBarPos = 0;
  bool _refresh = true;

  final ScrollController _scrollController = ScrollController();

  final Set<String> _animatedProductIds = {};

  @override
  void initState() {
    super.initState();

    // Cette méthode permet d'appeler mon provider une fois le widget construit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = Provider.of<ProductsProvider>(context, listen: false);
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() async {
    double currentScrollPos = _scrollController.position.pixels;

    if (currentScrollPos > _prevScrollPos) {
      setState(() => searchBarPos = -176);
    } else {
      setState(() => searchBarPos = 0);
    }

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        provider.hasMorePages &&
        _refresh) {
      _refresh = false;
      provider.products.addAll(
        await provider.searchProductsByQuery(method: 'more'),
      );
      Timer(Duration(seconds: 1), () => _refresh = true);
    }

    _prevScrollPos = currentScrollPos;
  }

  @override
  Widget build(BuildContext context) {
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
                    children: [AppSearchBar(provider: provider)],
                  ),
                ),
                const SizedBox(height: 12),
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.55,
                  ),
                  children:
                      provider.products.isEmpty
                          ? []
                          : provider.products.map((product) {
                            final productCard = ProductCard(
                              product: product,
                              widthAjustment: 16,
                            );

                            final alreadyAnimated = _animatedProductIds
                                .contains(product.id);

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
                                        duration: Duration(milliseconds: 250),
                                        builder: (context, value, child) {
                                          return Opacity(
                                            opacity: value,
                                            child: Transform.translate(
                                              offset: Offset(
                                                0,
                                                35 * (1 - value),
                                              ),
                                              child: child,
                                            ),
                                          );
                                        },
                                        child: productCard,
                                      )
                                      : Opacity(opacity: 0, child: productCard),
                            );
                          }).toList(),
                ),
                const SizedBox(height: 32),
                if (provider.productsIsLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
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
