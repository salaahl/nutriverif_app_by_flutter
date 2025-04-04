import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/my_app_bar.dart';
import '../widgets/product_card.dart';
import '../models/model_products.dart';
import 'package:provider/provider.dart';
import 'package:app_nutriverif/providers/products_provider.dart';

class ProductSearchPage extends StatefulWidget {
  final String? query;
  const ProductSearchPage({super.key, this.query});

  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'popularity_key';
  bool _isLoading = false;
  double _prevScrollPos = 0;
  bool _refresh = true;
  List<Products> _products = [];
  int _page = 1;
  final int _totalPages = 5;

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
    _scrollController.addListener(_onScroll);
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
        _page < _totalPages &&
        _refresh) {
      _refresh = false;
      _loadMoreProducts();
      Timer(Duration(seconds: 1), () => _refresh = true);
    }

    _prevScrollPos = currentScrollPos;
  }

  Future<void> _searchProducts() async {
    setState(() => _isLoading = true);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _products = List.generate(
        10,
        (index) => Products(
          id: '123456789',
          image: 'assets/images/logo.png',
          brand: 'Produit $index',
          name: 'Nom du produit $index',
          nutriscore: 'assets/images/logo.png',
          nova: 'assets/images/logo.png',
        ),
      );

      _isLoading = false;
    });
  }

  Future<void> _loadMoreProducts() async {
    setState(() => _isLoading = true);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _products.addAll(
        List.generate(
          5,
          (index) => Products(
            id: '123456789',
            image: 'assets/images/logo.png',
            brand: 'Produit $index',
            name: 'Nom du produit $index',
            nutriscore: 'assets/images/logo.png',
            nova: 'assets/images/logo.png',
          ),
        ),
      );
      _page++;
      _isLoading = false;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    final query = widget.query;

    if (query != null) {
      _searchProducts();
    }

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
                  onPressed: _searchProducts,
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
                      selected: _selectedFilter == filter.value,
                      onSelected: (selected) {
                        setState(() => _selectedFilter = filter.value);
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
            if (_products.isEmpty && !_isLoading)
              const Center(child: Text('Aucun produit trouvé')),

            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(_products.length, (index) {
                final product = _products[index];

                return ProductCard(
                  widthAjustment: 16,
                  imageUrl: product.image,
                  title: product.brand,
                  description: product.name,
                  nutriscore: product.nutriscore,
                  nova: product.nova,
                );
              }),
            ),

            const SizedBox(height: 32),

            // Loader bas de page
            if (_isLoading)
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
