// products_provider.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  String _filter = '';
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
        'energy': 2000,
        'fat': 70,
        'saturatedFat': 20,
        'carbohydrates': 260,
        'sugars': 90,
        'salt': 6,
        'fiber': 25,
        'proteins': 50,
      };
    } else {
      return {
        'energy': 2500,
        'fat': 95,
        'saturatedFat': 30,
        'carbohydrates': 300,
        'sugars': 120,
        'salt': 6,
        'fiber': 30,
        'proteins': 50,
      };
    }
  }

  void updateProducts(List<Products> value) {
    _products = value;
    // notifyListeners();
  }

  void updateAjrSelected(String value) {
    _ajrSelected = value;
    // notifyListeners();
  }

  void updateInput(String value) {
    _input = value;
    // notifyListeners();
  }

  void updateFilter(String value) {
    _filter = value;
    // notifyListeners();
  }

  Future<void> searchProducts(
    String? userInput,
    String? sortBy,
    String method,
  ) async {
    if (userInput != null) _input = userInput;
    if (sortBy != null) _filter = sortBy;
    if (method == 'complete') {
      _products = [];
      _page = 1;
    } else if (method == 'more') {
      _page++;
    }

    const fields =
        'id,image_front_small_url,brands,generic_name_fr,nutriscore_grade,nova_group';
    final url =
        '$apiBaseUrl?search_terms=${Uri.encodeComponent(_input)}&fields=${Uri.encodeComponent(fields)}&purchase_places_tags=france&sort_by=${Uri.encodeComponent(_filter)}&page_size=20&page=$_page&search_simple=1&action=process&json=1';

    try {
      _productsIsLoading = true;
      _error = null;
      notifyListeners();

      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (method == 'complete') _pages = (data['count'] / 20).ceil();
      _products.addAll(
        (data['products'] as List).map((p) => Products.fromJson(p)).toList(),
      );

      // notifyListeners();
    } catch (e) {
      _error = e.toString();
      // notifyListeners();
    } finally {
      _productsIsLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProduct(String id) async {
    _productIsLoading = true;
    _error = null;
    // Utiliser addPostFrameCallback pour exécuter après la phase de build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      final url = 'https://world.openfoodfacts.org/api/v3/product/$id.json';
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      _product = Product.fromJson(data['product']);

      fetchSuggestedProducts(id: _product.id, category: _product.category);
      // notifyListeners();
    } catch (e) {
      _error = e.toString();
      // notifyListeners();
    } finally {
      _productIsLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLastProducts() async {
    _lastProductsIsLoading = true;
    _error = null;
    // Utiliser addPostFrameCallback pour exécuter après la phase de build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

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

      // notifyListeners();
    } catch (e) {
      _error = e.toString();
      // notifyListeners();
    } finally {
      _lastProductsIsLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSuggestedProducts({String? id, String? category}) async {
    if (_suggestedProductsIsLoading)
      return;

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
                                num.parse(_product.novaGroup.toString()))) &&
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

      // notifyListeners();
    } catch (e) {
      _error = e.toString();
      // notifyListeners();
    } finally {
      _suggestedProductsIsLoading = false;
      notifyListeners();
    }
  }
}
