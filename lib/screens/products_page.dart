import 'package:flutter/material.dart';
import 'dart:async';
import 'package:app_nutriverif/providers/products_provider.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/product_card.dart';
import '../models/model_products.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({super.key});

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
    'Nom du produit': 'product_name',
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(172),
        child: customAppBar(),
      ),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            // BoxDeco à sup
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2,
              ), // Bordure noire autour du container
            ),
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText:
                          'Entrez un nom de produit, un code-barres, une marque ou un type d\'aliment',
                      hintStyle: const TextStyle(
                        color: Colors.grey, // Texte gris pour le placeholder
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
                          color: Color(0xFF9CA3AF), // focus:border-gray-400
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
                    child: Icon(Icons.search, color: Colors.white),
                  ),
                  onPressed: _searchProducts,
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            // BoxDeco à sup
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue,
                width: 2,
              ), // Bordure noire autour du container
            ),
            margin: EdgeInsets.only(top: 10),
            child: Wrap(
              children:
                  _filters.entries
                      .map(
                        (filter) => Container(
                          // BoxDeco à sup
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.yellow,
                              width: 2,
                            ), // Bordure noire autour du container
                          ),
                          margin: EdgeInsets.only(right: 10, bottom: 10),
                          child: FilterChip(
                            label: Text(filter.key),
                            selected: _selectedFilter == filter.value,
                            onSelected: (selected) {
                              setState(() => _selectedFilter = filter.value);
                            },
                            backgroundColor: Colors.grey,
                            selectedColor: Color.fromRGBO(0, 189, 126, 1),
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                            showCheckmark: false,
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
          Expanded(
            child:
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        // BoxDeco à sup
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.brown,
                            width: 2,
                          ), // Bordure noire autour du container
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Wrap(
                          children: List.generate(_products.length, (index) {
                            var product = _products[index];
                            bool applyMargin = index % 2 == 0;

                            return Container(
                              margin:
                                  applyMargin
                                      ? EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width /
                                            100 *
                                            4,
                                      )
                                      : EdgeInsets
                                          .zero, // Applique le margin sur les éléments pairs
                              child: ProductCard(
                                widthAjustment: 16,
                                imageUrl: product.image,
                                title: product.brand,
                                description: product.name,
                                nutriscore: product.nutriscore,
                                nova: product.nova,
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}

/* observations :
1. Les calculs en MediaQuery sont tenables mais il faudra penser à leur soustraire par exemple le padding si j'en définis un plus tard, sinon ça débordera
*/
