// products_provider.dart
import 'package:flutter/material.dart';
import '../models/model_products.dart';

class ProductsProvider with ChangeNotifier {
  static const String apiBaseUrl =
      'https://world.openfoodfacts.org/cgi/search.pl';

  List<Products> _products = [];
  bool _productsIsLoading = false;
  Product _product = Product.fromJson({});
  bool _productIsLoading = false;
  List<Products> _lastProducts = [];
  bool _lastProductsIsLoading = false;
  List<Products> _suggestedProducts = [];
  bool _suggestedProductsIsLoading = false;
  String _ajrSelected = 'women';
  String _input = '';
  String _filter = 'popularity_key';
  int _page = 1;
  int _pages = 1;
  String? _error;

  List<Products> get products => _products;
  bool get productsIsLoading => _productsIsLoading;
  Product get product => _product;
  bool get productIsLoading => _productIsLoading;
  List<Products> get lastProducts => _lastProducts;
  bool get lastProductsIsLoading => _lastProductsIsLoading;
  List<Products> get suggestedProducts => _suggestedProducts;
  bool get suggestedProductsIsLoading => _suggestedProductsIsLoading;
  String get ajrSelected => _ajrSelected;
  String get input => _input;
  String get filter => _filter;
  int get page => _page;
  int get pages => _pages;
  String? get error => _error;

  Map<String, double> get ajrValues {
    if (_ajrSelected == 'women') {
      return {
        'energy-kcal_serving': 2000,
        'fat_serving': 70,
        'saturated-fat_serving': 20,
        'carbohydrates_serving': 260,
        'sugars_serving': 90,
        'salt_serving': 6,
        'fiber_serving': 25,
        'proteins_serving': 50,
      };
    } else {
      return {
        'energy-kcal_serving': 2500,
        'fat_serving': 95,
        'saturated-fat_serving': 30,
        'carbohydrates_serving': 300,
        'sugars_serving': 120,
        'salt_serving': 6,
        'fiber_serving': 30,
        'proteins_serving': 50,
      };
    }
  }

  void updateAjrSelected(String value) {
    if (_ajrSelected == value) return;

    _ajrSelected = value;
    notifyListeners();
  }

  void updateInput(String value) {
    if (_input == value) return;

    _input = value;
    notifyListeners();
  }

  void updateFilter(String value) {
    if (_filter == value) return;

    _filter = value;

    // Relancer une recherche de produits avec le nouveau filtre si des produits sont actuellement affichés
    if (products.isNotEmpty) {
      searchProducts(userInput: _input, sortBy: value, method: 'complete');
    } else {
      // Sinon, notifier les listeners que la tâche est terminée
      notifyListeners();
    }
  }

  Future<void> searchProducts({
    String userInput = '',
    String sortBy = 'popularity_key',
    required String method,
  }) async {
    if (method == 'more') {
      _page++;
    } else {
      _products = [];
      _input = userInput;
      _page = 1;
      _pages = 2;
    }

    try {
      _productsIsLoading = true;
      notifyListeners();

      await Future.delayed(Duration(seconds: 3));

      _products.addAll(
        List.generate(
          4,
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
    } catch (e) {
      _error = e.toString();
    } finally {
      _productsIsLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProduct(String id) async {
    if (productIsLoading) return;

    _productIsLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 3));
    _product = Product(
      id: '123456789',
      image: 'assets/images/logo.png',
      brand: 'Produit',
      genericName: 'Nom du produit',
      category: 'Catégorie',
      categories: ['Catégorie 1', 'Catégorie 2'],
      nutriscore: 'assets/images/logo.png',
      nova: 'assets/images/logo.png',
      lastUpdate: '01/01/2023',
      quantity: '300g',
      servingSize: '100g',
      ingredients: String.fromCharCode(33),
      nutriments: {
        'energy-kcal_serving': '225',
        'fat_serving': '7.5',
        'saturated-fat_serving': '3.0',
        'carbohydrates_serving': '30.0',
        'sugars_serving': '15.0',
        'salt_serving': '0.3',
        'fiber_serving': '1.5',
        'proteins_serving': '9.0',
      },
      nutrientLevels: {
        "fat": "high",
        "salt": "low",
        "saturated-fat": "high",
        "sugars": "high",
      },
      manufacturingPlace: 'France',
      link: 'assets/images/logo.png',
    );

    _productIsLoading = false;
    notifyListeners();

    fetchSuggestedProducts();
  }

  Future<void> fetchLastProducts() async {
    if (_lastProductsIsLoading) return;

    _lastProductsIsLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 3));
    _lastProducts = List.generate(
      4,
      (index) => Products(
        id: '123456789',
        image: 'assets/images/logo.png',
        brand: 'Produit $index',
        name: 'Nom du produit $index',
        nutriscore: 'assets/images/logo.png',
        nova: 'assets/images/logo.png',
      ),
    );

    _lastProductsIsLoading = false;
    notifyListeners();
  }

  Future<void> fetchSuggestedProducts() async {
    if (_suggestedProductsIsLoading) return;

    _suggestedProductsIsLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 3));
    _suggestedProducts = List.generate(
      4,
      (index) => Products(
        id: '123456789',
        image: 'assets/images/logo.png',
        brand: 'Produit $index',
        name: 'Nom du produit $index',
        nutriscore: 'assets/images/logo.png',
        nova: 'assets/images/logo.png',
      ),
    );

    _suggestedProductsIsLoading = false;
    notifyListeners();
  }

  /* Appels API à remettre lors que le code sera opérationnel
  Future<void> searchProducts({
    String userInput = '',
    String sortBy = 'popularity_key',
    required String method,
  }) async {
    if (method == 'more') {
      _page++;
    } else {
      _products = [];
      _input = userInput;
      _page = 1;
    }

    const fields =
        'id,image_front_small_url,brands,generic_name_fr,nutriscore_grade,nova_group';
    final url =
        '$apiBaseUrl?search_terms=${Uri.encodeComponent(_input)}&fields=${Uri.encodeComponent(fields)}&purchase_places_tags=france&sort_by=${Uri.encodeComponent(_filter)}&page_size=20&page=$_page&search_simple=1&action=process&json=1';

    try {
      _error = null;
      _productsIsLoading = true;
      notifyListeners();

      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (method == 'complete') _pages = (data['count'] / 20).ceil();
      _products.addAll(
        (data['products'] as List).map((p) => Products.fromJson(p)).toList(),
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _productsIsLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProduct(String id) async {
    _error = null;
    _productIsLoading = true;
    notifyListeners();

    try {
      final url = 'https://world.openfoodfacts.org/api/v3/product/$id.json';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['product'] != null) {
          _product = Product.fromJson(data['product']);

          fetchSuggestedProducts(id: _product.id, category: _product.category);
        } else {
          _error = 'Produit non trouvé';
        }
      } else {
        _error = 'Erreur HTTP ${response.statusCode}: ${response.reasonPhrase}';
      }
    } catch (e) {
      // Gère les erreurs réseau
      _error = 'Erreur réseau: $e';
    } finally {
      _productIsLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSuggestedProducts({String? id, String? category}) async {
    if (_suggestedProductsIsLoading) return;

    id ??= _product.id;
    category ??= _product.category;

    _suggestedProductsIsLoading = true;
    _error = null;
    notifyListeners();

    const fields =
        'id,image_front_small_url,brands,generic_name_fr,nutriscore_grade,nova_group,completeness,popularity_key';
    final url =
        'https://world.openfoodfacts.org/api/v2/search?categories_tags=${Uri.encodeComponent(category)}&fields=${Uri.encodeComponent(fields)}&purchase_places_tags=france&sort_by=nutriscore_score,nova_group,popularity_key&page_size=300&action=process&json=1';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      const score = ['a', 'b', 'c', 'd', 'e'];
      final selectedProducts =
          (data['products'] as List)
              .where(
                (e) =>
                    e['id'] != id &&
                    e['nutriscore_grade'] != 'not-applicable' &&
                    e['nutriscore_grade'] != 'unknown' &&
                    (score.indexOf(e['nutriscore_grade']) <
                            score.indexOf(_product.nutriscore) ||
                        (score.indexOf(e['nutriscore_grade']) ==
                                score.indexOf(_product.nutriscore) &&
                            e['nova_group'] is num &&
                            e['nova_group'] <
                                num.parse(_product.nova.toString()))) &&
                    (e['completeness'] as double) >= 0.35,
              )
              .toList()
            ..sort((a, b) {
              final nutriscoreComp =
                  score.indexOf(a['nutriscore_grade']) -
                  score.indexOf(b['nutriscore_grade']);
              if (nutriscoreComp != 0) return nutriscoreComp;
              final novaComp =
                  (a['nova_group'] as num) - (b['nova_group'] as num);
              if (novaComp != 0) return novaComp.toInt();
              return (b['popularity_key'] as int) -
                  (a['popularity_key'] as int);
            });
      _suggestedProducts =
          selectedProducts.take(4).map((p) => Products.fromJson(p)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _suggestedProductsIsLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLastProducts() async {
    _error = null;
    _lastProductsIsLoading = true;
    notifyListeners();

    const fields =
        'id,image_front_small_url,brands,generic_name_fr,nutriscore_grade,nova_group,created_t,completeness';
    final url =
        '$apiBaseUrl?&fields=${Uri.encodeComponent(fields)}&purchase_places_tags=france&sort_by=created_t&page_size=300&action=process&json=1';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      final filteredProducts =
          (data['products'] as List)
              .where((p) => (p['completeness'] as double) >= 0.35)
              .toList()
            ..sort(
              (a, b) =>
                  (b['created_t'] as int).compareTo(a['created_t'] as int),
            );
      _lastProducts =
          filteredProducts.take(5).map((p) => Products.fromJson(p)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _lastProductsIsLoading = false;
      notifyListeners();
    }
  }
  */
}
