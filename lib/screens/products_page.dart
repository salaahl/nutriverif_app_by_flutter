import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/custom_app_bar.dart';
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
  late TextEditingController _searchController = TextEditingController();

  double _prevScrollPos = 0;
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

    // Cette méthode permet d'appeler mon provider une fois le widget est construit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProductsProvider>(context, listen: false);
    });

    _scrollController.addListener(_onScroll);
  }

  // Contrairement au initState qui n'est appelé qu'une seule fois, didChangeDependencies est appelé à chaque retour sur la page
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (provider.input.isNotEmpty) {
      _searchController = TextEditingController(text: provider.input);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    double currentScrollPos = _scrollController.position.pixels;

    if (currentScrollPos > _prevScrollPos) {
      setState(() => print('scroll vers le bas'));
    } else {
      setState(() => print('scroll vers le haut'));
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
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barre de recherche
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Entrez un nom de produit, un code-barres...',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 8.0),
                        child: Icon(Icons.search, color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(999.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(156, 163, 175, 1),
                          width: 4.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(999.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(229, 231, 235, 1),
                          width: 4.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(999.0),
                        borderSide: const BorderSide(
                          color: Color(0xFF9CA3AF),
                          width: 4.0,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 12.0,
                      ),
                    ),
                    style: const TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ),
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[800],
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: const Icon(Icons.search, color: Colors.white),
                  ),
                  onPressed:
                      () => {
                        if (_searchController.text.trim().length < 2)
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Le champ doit contenir au moins deux caractères',
                                ),
                              ),
                            ),
                          }
                        else
                          {
                            provider.searchProducts(
                              userInput: _searchController.text,
                              sortBy: provider.filter,
                              method: 'complete',
                            ),
                          },
                      },
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Filtres
            Wrap(
              spacing: 12,
              children:
                  _filters.entries.map((filter) {
                    return FilterChip(
                      label: Text(filter.key),
                      selected: provider.filter == filter.value,
                      onSelected: (selected) {
                        setState(() => provider.updateFilter(filter.value));
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

            const SizedBox(height: 24),

            // Produits
            if (provider.products.isEmpty && !provider.productsIsLoading)
              const Center(child: Text('Aucun produit trouvé')),

            Wrap(
              spacing: 16,
              runSpacing: 16,
              children:
                  provider.products.asMap().entries.map((entry) {
                    final index = entry.key;
                    final product = entry.value;

                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(
                        milliseconds: 500 + (index * 100),
                      ),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(
                              0,
                              30 * (1 - value),
                            ),
                            child: child,
                          ),
                        );
                      },
                      child: ProductCard(
                        widthAjustment: 16,
                        imageUrl: product.image,
                        title: product.brand,
                        description: product.name,
                        nutriscore: "assets/images/logo.png",
                        nova: "assets/images/logo.png",
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 32),
            // Loader bas de page
            if (provider.productsIsLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
