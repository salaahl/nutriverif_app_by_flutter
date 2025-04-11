import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/app_bar.dart';
import '../widgets/search_bar.dart';
import '../widgets/product_card.dart';
import 'package:provider/provider.dart';
import 'package:app_nutriverif/providers/products_provider.dart';

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

  final Map<String, String> _filters = {
    'Popularité': 'popularity_key',
    'Nom': 'product_name',
    'Date de création': 'created_t',
    'Nutriscore': 'nutriscore_score',
    'Nova Score': 'nova_score',
  };

  @override
  void initState() {
    super.initState();

    // Cette méthode permet d'appeler mon provider une fois le widget construit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // provider = Provider.of<ProductsProvider>(context, listen: false);
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    double currentScrollPos = _scrollController.position.pixels;

    if (currentScrollPos > _prevScrollPos) {
      setState(() => searchBarPos = -176);
    } else {
      setState(() => searchBarPos = 0);
    }

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        provider.page < provider.pages &&
        _refresh) {
      _refresh = false;
      provider.searchProducts(method: 'more');
      Timer(Duration(seconds: 1), () => _refresh = true);
    }

    _prevScrollPos = currentScrollPos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(172),
        child: customAppBar(),
      ),
      body: Stack(
        children: [
          // Contenu défilable en dessous de la searchbar + filtres
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(
              16,
              176, // <-- HAUTEUR de la barre fixe
              16,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.64,
                  ),
                  children:
                      provider.products.asMap().entries.map((entry) {
                        final index = entry.key;
                        final product = entry.value;

                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: Duration(milliseconds: 500 + (index * 100)),
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 30 * (1 - value)),
                                child: child,
                              ),
                            );
                          },
                          child: ProductCard(
                            id: product.id,
                            widthAjustment: 16,
                            imageUrl: product.image,
                            title: product.brand,
                            description: product.name,
                            nutriscore: product.nutriscore,
                            nova: product.nova,
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 32),
                if (provider.productsIsLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(
                        color: Color(0xFF00BD7E),
                        strokeWidth: 8,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // AppSearchBar + filtres
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: searchBarPos,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSearchBar(provider: provider),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    children:
                        _filters.entries.map((filter) {
                          return FilterChip(
                            label: Text(filter.key),
                            selected: provider.filter == filter.value,
                            onSelected: (selected) {
                              setState(
                                () => provider.updateFilter(filter.value),
                              );
                            },
                            backgroundColor: Colors.grey,
                            selectedColor: const Color.fromRGBO(0, 189, 126, 1),
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                            showCheckmark: false,
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
