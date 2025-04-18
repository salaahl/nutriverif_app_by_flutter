// products_provider.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
          try {
            _product = Product.fromJson(data['product']);
            notifyListeners();

            fetchSuggestedProducts(
              id: _product.id,
              categories: _product.categories,
            );
          } catch (e) {
            _error = 'Erreur lors du parsing du produit: $e';
          }
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

  Future<void> fetchSuggestedProducts({
    String? id,
    List<String>? categories,
  }) async {
    id ??= _product.id;
    categories ??= _product.categories;

    String categoriesString = categories.join(',');

    _suggestedProducts = [];
    _suggestedProductsIsLoading = true;
    _error = null;
    notifyListeners();

    const fields =
        'id,image_front_small_url,brands,generic_name_fr,nutriscore_grade,nova_group,completeness,popularity_key';
    final url =
        'https://world.openfoodfacts.org/api/v2/search?categories_tags=${Uri.encodeComponent(categoriesString)}&fields=${Uri.encodeComponent(fields)}&purchase_places_tags=france&sort_by=nutriscore_score,nova_group,popularity_key&page_size=300&action=process&json=1';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      const score = ['a', 'b', 'c', 'd', 'e'];

      final selectedProducts =
          (data['products'] as List).where((e) {
              final eNutriscore = e['nutriscore_grade'];
              final eNova = e['nova_group'];
              final completeness = e['completeness'];
              final eId = e['id'];

              if (eId == null || eId == id) return false;
              if (eNutriscore == 'not-applicable' || eNutriscore == 'unknown')
                return false;
              if (!score.contains(eNutriscore) ||
                  !score.contains(_product.nutriscore))
                return false;

              final scoreDiff = score
                  .indexOf(eNutriscore)
                  .compareTo(score.indexOf(_product.nutriscore));
              final bothNovaOk = eNova is num && _product.nova is num;

              if (scoreDiff < 0) return true;
              if (scoreDiff == 0 &&
                  bothNovaOk &&
                  eNova < (_product.nova as num))
                return true;

              if (completeness is double && completeness >= 0.35) return true;

              return false;
            }).toList()
            ..sort((a, b) {
              final aScore = score.indexOf(a['nutriscore_grade']);
              final bScore = score.indexOf(b['nutriscore_grade']);
              final scoreComp = aScore.compareTo(bScore);
              if (scoreComp != 0) return scoreComp;

              final aNova = a['nova_group'];
              final bNova = b['nova_group'];
              if (aNova is num && bNova is num) {
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
        _suggestedProducts =
            selectedProducts.take(4).map((p) => Products.fromJson(p)).toList();
      } catch (e) {
        _error = 'Erreur lors du parsing du produit: $e';
      }
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
              .where((p) => (p['completeness'] as num).toDouble() >= 0.35)
              .toList()
            ..sort(
              (a, b) => (b['created_t'] as num).toDouble().compareTo(
                (a['created_t'] as num).toDouble(),
              ),
            );
      _lastProducts =
          filteredProducts.take(4).map((p) => Products.fromJson(p)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _lastProductsIsLoading = false;
      notifyListeners();
    }
  }
}
