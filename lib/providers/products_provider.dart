import 'package:flutter/material.dart';

import '../models/model_products.dart';
import '../core/services/products_service.dart';
import '../core/services/translate_service.dart';

class ProductsProvider with ChangeNotifier {
  final ProductsService _productsService = ProductsService();
  final TranslateService _translateService = TranslateService();

  final List<Product> _products = [];
  bool _productsIsLoading = false;
  Product _product = Product.fromJson({});
  Product _productDemo = Product.fromJson({});
  bool _productIsLoading = false;
  final List<Product> _lastProducts = [];
  bool _lastProductsIsLoading = false;
  final List<Product> _suggestedProducts = [];
  final List<Product> _suggestedProductsDemo = [];
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
  Product get productDemo => _productDemo;
  bool get productIsLoading => _productIsLoading;
  List<Product> get lastProducts => _lastProducts;
  bool get lastProductsIsLoading => _lastProductsIsLoading;
  List<Product> get suggestedProducts => _suggestedProducts;
  List<Product> get suggestedProductsDemo => _suggestedProductsDemo;
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

  void setProducts(List<Product> products, String method) {
    if (method == 'complete') _products.clear();
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

  void setProductDemo(Product product) {
    _productDemo = product;
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

  void setSuggestedProductsDemo(List<Product> products) {
    _suggestedProductsDemo.clear();
    _suggestedProductsDemo.addAll(products);
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

  Future<List<String>> getTranslatedCategories(List<String> categories) async {
    String cleanCategory(String cat, String langPrefix) {
      return cat
          .trim()
          .replaceFirst(RegExp('^$langPrefix:'), '')
          .replaceAll('-', ' ')
          .trim();
    }

    final frenchCategories =
        categories
            .where((c) => c.startsWith('fr:'))
            .map((c) => cleanCategory(c, 'fr'))
            .toList();

    final englishCategories =
        categories
            .where((c) => c.startsWith('en:'))
            .map((c) => cleanCategory(c, 'en'))
            .toList();

    final categoriesToTranslate = englishCategories
        .take(4 - frenchCategories.length)
        .join('<SEP>');

    if (categoriesToTranslate.isEmpty) {
      return [...frenchCategories, ...englishCategories];
    }

    List<String> translatedCategories = [];

    try {
      final data = await _translateService.getTranslation(
        text: categoriesToTranslate,
        lang: 'FR',
      );
      translatedCategories = data.split('<SEP>').map((c) => c.trim()).toList();
    } catch (e) {
      setError('Erreur pendant la traduction: $e');
      // Je récupère quand meme les categories en anglais
      translatedCategories =
          englishCategories.take(4 - frenchCategories.length).toList();
    }

    return [...frenchCategories, ...translatedCategories];
  }

  Future<void> searchProducts({
    String query = '',
    String selected = 'popularity_key',
    required String method,
  }) async {
    setError(null);

    if (method == 'more') {
      _page++;
    } else {
      setProducts([], method);
      if (query.isNotEmpty) setInput(query);
      if (selected.isNotEmpty) setFilter(selected);
      setPage(1);
    }

    setProductsIsLoading(true);

    try {
      final data = await _productsService.searchProductsByQuery(
        query: _input,
        sortBy: _filter,
        page: _page,
      );

      if (method == 'complete') {
        setPages((data['count'] / 20).ceil());
      }

      final products =
          (data['products'] as List).map((p) => Product.fromJson(p)).toList();

      setProducts(products, method);
    } catch (e) {
      setError('search product error: $e');
      setProducts([], method);
    } finally {
      setProductsIsLoading(false);
    }
  }

  Future<void> loadProductById(String id) async {
    setError(null);
    setProductIsLoading(true);

    try {
      setProduct(await _productsService.fetchProductById(id));
    } catch (e) {
      setError('single product error: $e');
      setProduct(Product.fromJson({}));
    } finally {
      setProductIsLoading(false);
    }
  }

  Future<void> loadSuggestedProducts({
    required String id,
    required List<String> categories,
    required String nutriscore,
    required String nova,
  }) async {
    setError(null);
    setSuggestedProductsIsLoading(true);

    try {
      final result = await _productsService.fetchSuggestedProducts(
        id: id,
        categories: categories,
        nutriscore: nutriscore,
        nova: nova,
      );

      setSuggestedProducts(result);
    } catch (e) {
      setError('suggestion product error: $e');
      setSuggestedProducts([]);
    } finally {
      setSuggestedProductsIsLoading(false);
    }
  }

  Future<void> loadLastProducts() async {
    setError(null);
    setLastProductsIsLoading(true);

    try {
      final products = await _productsService.fetchLastProducts();
      setLastProducts(products);
    } catch (e) {
      setError('last products error: $e');
      setLastProducts([]);
    } finally {
      setLastProductsIsLoading(false);
    }
  }
}
