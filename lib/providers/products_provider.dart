import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/model_products.dart';

class ProductsProvider with ChangeNotifier {
  static const String _apiBaseUrl =
      'https://world.openfoodfacts.org/cgi/search.pl';

  static const String fields =
      'id,image_url,brands,generic_name_fr,main_category_fr,categories_tags,created_t,last_modified_t,nutriscore_grade,nova_group,quantity,serving_size,ingredients_text_fr,nutriments,nutrient_levels,manufacturing_places,url,completeness,popularity_key';

  final List<Product> _products = [];
  bool _productsIsLoading = false;
  Product _product = Product.fromJson({});
  bool _productIsLoading = false;
  final List<Product> _lastProducts = [];
  bool _lastProductsIsLoading = false;
  final List<Product> _suggestedProducts = [];
  bool _suggestedProductsIsLoading = false;
  String _ajrSelected = 'women';
  String _input = '';
  String _filter = 'popularity_key';
  int _page = 1;
  int _pages = 1;
  String? _error;

  List<Product> get products => _products;
  bool get productsIsLoading => _productsIsLoading;
  Product get product => _product;
  bool get productIsLoading => _productIsLoading;
  List<Product> get lastProducts => _lastProducts;
  bool get lastProductsIsLoading => _lastProductsIsLoading;
  List<Product> get suggestedProducts => _suggestedProducts;
  bool get suggestedProductsIsLoading => _suggestedProductsIsLoading;
  String get ajrSelected => _ajrSelected;
  String get input => _input;
  String get filter => _filter;
  int get page => _page;
  int get pages => _pages;
  bool get hasMorePages => _page < _pages;
  String? get error => _error;

  Map<String, Map<String, dynamic>> get ajrValues {
    if (_ajrSelected == 'women') {
      return {
        'energy-kcal_serving': {'name': 'Énergie (kcal)', 'value': 2000},
        'fat_serving': {'name': 'Matières grasses', 'value': 70},
        'saturated-fat_serving': {'name': 'Acides gras saturés', 'value': 20},
        'carbohydrates_serving': {'name': 'Glucides', 'value': 260},
        'sugars_serving': {'name': 'Sucres', 'value': 90},
        'salt_serving': {'name': 'Sel', 'value': 6},
        'fiber_serving': {'name': 'Fibres alimentaires', 'value': 25},
        'proteins_serving': {'name': 'Protéines', 'value': 50},
      };
    } else {
      return {
        'energy-kcal_serving': {'name': 'Énergie (kcal)', 'value': 2500},
        'fat_serving': {'name': 'Matières grasses', 'value': 95},
        'saturated-fat_serving': {'name': 'Acides gras saturés', 'value': 30},
        'carbohydrates_serving': {'name': 'Glucides', 'value': 300},
        'sugars_serving': {'name': 'Sucres', 'value': 120},
        'salt_serving': {'name': 'Sel', 'value': 6},
        'fiber_serving': {'name': 'Fibres alimentaires', 'value': 30},
        'proteins_serving': {'name': 'Protéines', 'value': 50},
      };
    }
  }

  void addProducts(List<Product> newProducts) {
    _products.addAll(newProducts);
    notifyListeners();
  }

  void setProducts(List<Product> products) {
    _products.clear();
    _products.addAll(products);
    notifyListeners();
  }

  void setProductsIsLoading(bool isLoading) {
    _productsIsLoading = isLoading;
    notifyListeners();
  }

  void setProduct(Product product) {
    _product = product;
    notifyListeners();
  }

  void setProductIsLoading(bool isLoading) {
    _productIsLoading = isLoading;
    notifyListeners();
  }

  void setLastProducts(List<Product> products) {
    _lastProducts.clear();
    _lastProducts.addAll(products);
    notifyListeners();
  }

  void setLastProductsIsLoading(bool isLoading) {
    _lastProductsIsLoading = isLoading;
    notifyListeners();
  }

  void setSuggestedProducts(List<Product> products) {
    _suggestedProducts.clear();
    _suggestedProducts.addAll(products);
    notifyListeners();
  }

  void setSuggestedProductsIsLoading(bool isLoading) {
    _suggestedProductsIsLoading = isLoading;
    notifyListeners();
  }

  void setAjrSelected(String ajr) {
    _ajrSelected = ajr;
    notifyListeners();
  }

  void setInput(String input) {
    _input = input;
    notifyListeners();
  }

  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }

  void setPage(int page) {
    _page = page;
    notifyListeners();
  }

  void setPages(int pages) {
    _pages = pages;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<Map<String, dynamic>> _getJson(String url) async {
    final response = await http
        .get(Uri.parse(url))
        .timeout(Duration(seconds: 30));
    return json.decode(response.body);
  }

  Future<List<Product>> searchProductsByQuery({
    String query = '',
    String selected = 'popularity_key',
    required String method,
  }) async {
    _error = null;

    if (method == 'more') {
      _page++;
    } else {
      setProducts([]);
      if (query.isNotEmpty) _input = query;
      if (selected.isNotEmpty) _filter = selected;
      _page = 1;
    }

    setProductsIsLoading(true);

    final url =
        '$_apiBaseUrl?search_terms=${Uri.encodeComponent(input)}&fields=${Uri.encodeComponent(fields)}&purchase_places_tags=france&sort_by=${Uri.encodeComponent(filter)}&page_size=20&page=$page&search_simple=1&action=process&json=1';

    try {
      final data = await _getJson(url);

      if (method == 'complete') _pages = (data['count'] / 20).ceil();

      return (data['products'] as List)
          .map((p) => Product.fromJson(p))
          .toList();
    } catch (e) {
      _error = 'search product error: ${e.toString()}';
      return [];
    } finally {
      setProductsIsLoading(false);
    }
  }

  Future<Product> fetchProductById(String id) async {
    _error = null;
    setProductIsLoading(true);

    final url =
        'https://world.openfoodfacts.org/api/v3/product/$id?fields=$fields';

    try {
      final data = await _getJson(url);

      return Product.fromJson(data['product']);
    } catch (e) {
      _error = 'single product error: ${e.toString()}';
      return Product.fromJson({});
    } finally {
      setProductIsLoading(false);
    }
  }

  Future<List<Product>> fetchSuggestedProducts({
    required String id,
    required List<String> categories,
    required String nutriscore,
    required String nova,
  }) async {
    _error = null;
    setSuggestedProductsIsLoading(true);

    const fields =
        'id,image_url,brands,generic_name_fr,main_category_fr,main_category_fr,categories_tags,last_modified_t,nutriscore_grade,nova_group,quantity,serving_size,ingredients_text_fr,nutriments,nutrient_levels,manufacturing_places,url,completeness,popularity_key';
    final url =
        'https://world.openfoodfacts.org/api/v2/search?categories_tags=${Uri.encodeComponent(categories.last)}&fields=${Uri.encodeComponent(fields)}&purchase_places_tags=france&sort_by=nutriscore_score,nova_group,popularity_key&page_size=300&action=process&json=1';

    try {
      final data = await _getJson(url);

      const score = ['a', 'b', 'c', 'd', 'e'];

      final selectedProducts =
          (data['products'] as List).where((e) {
              final eNutriscore = e['nutriscore_grade'];
              final eNova = e['nova_group'];
              final completeness = e['completeness'];
              final eId = e['id'] ?? e['code'];

              if (eId == null || eId == id) {
                return false;
              }

              if (eNutriscore == 'not-applicable' || eNutriscore == 'unknown') {
                return false;
              }

              if (!score.contains(eNutriscore) || !score.contains(nutriscore)) {
                return false;
              }

              final eScoreIndex = score.indexOf(eNutriscore);
              final pScoreIndex = score.indexOf(nutriscore);
              final scoreDiff = eScoreIndex.compareTo(pScoreIndex);

              final eNovaParsed = num.tryParse(eNova.toString());
              final pNovaParsed = num.tryParse(nova);
              final bothNovaOk = eNovaParsed != null && pNovaParsed != null;

              if (scoreDiff < 0) {
                return true;
              }

              if (scoreDiff == 0 && bothNovaOk && eNovaParsed < pNovaParsed) {
                return true;
              }

              if (completeness is double && completeness >= 0.35) {
                return true;
              }

              return false;
            }).toList()
            ..sort((a, b) {
              final aScore = score.indexOf(a['nutriscore_grade']);
              final bScore = score.indexOf(b['nutriscore_grade']);
              final scoreComp = aScore.compareTo(bScore);
              if (scoreComp != 0) return scoreComp;

              final aNova = num.tryParse(a['nova_group'].toString());
              final bNova = num.tryParse(b['nova_group'].toString());
              if (aNova != null && bNova != null) {
                final novaComp = (aNova - bNova).toInt();
                if (novaComp != 0) return novaComp;
              }

              final aPop = a['popularity_key'];
              final bPop = b['popularity_key'];
              if (aPop is int && bPop is int) {
                return bPop - aPop;
              }

              return 0;
            });
      try {
        final result =
            selectedProducts.take(4).map((p) => Product.fromJson(p)).toList();
        return result;
      } catch (e) {
        return [];
      }
    } catch (e) {
      _error = 'suggestion product error: ${e.toString()}';
      return [];
    } finally {
      setSuggestedProductsIsLoading(false);
    }
  }

  Future<List<Product>> fetchLastProducts() async {
    _error = null;
    setLastProductsIsLoading(true);

    final url =
        '$_apiBaseUrl?&fields=${Uri.encodeComponent(fields)}&purchase_places_tags=france&sort_by=created_t&page_size=300&action=process&json=1';

    try {
      final data = await _getJson(url);

      final filteredProducts =
          (data['products'] as List)
              .where((p) => (p['completeness'] as num).toDouble() >= 0.35)
              .toList()
            ..sort(
              (a, b) => (b['created_t'] as num).toDouble().compareTo(
                (a['created_t'] as num).toDouble(),
              ),
            );

      return filteredProducts.take(4).map((p) => Product.fromJson(p)).toList();
    } catch (e) {
      _error = 'last products error: ${e.toString()}';
      return [];
    } finally {
      setLastProductsIsLoading(false);
    }
  }
}
