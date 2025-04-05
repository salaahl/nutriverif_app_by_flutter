import 'package:flutter/material.dart';

class ProductsProvider with ChangeNotifier {
  double sectionsMargin = 32;
}






Future<void> searchProducts() async {
  _productsIsLoading = true;
  notifyListeners();

  await Future.delayed(Duration(seconds: 2));
  _products = List.generate(
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

  _productsIsLoading = false;
  notifyListeners();
}

/*
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
  */
