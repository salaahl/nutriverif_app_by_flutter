import '../../models/model_products.dart';
import 'products_service.dart';

class MockProductsService extends ProductsService {
  // Liste de Maps JSON brutes
  final List<Map<String, dynamic>> _fakeProductsJson = [
    {
      'code': '3017620422003',
      'id': '3017620422003',
      'image_front_small_url':
          'https://images.openfoodfacts.org/images/products/301/762/042/2003/front_fr.429.400.jpg',
      'image_front_url':
          'https://images.openfoodfacts.org/images/products/301/762/042/2003/front_fr.429.400.jpg',
      'brands': ['Nutella'],
      'product_name': 'Pâte à tartiner aux noisettes et au cacao',
      'product_name_fr': 'Pâte à tartiner aux noisettes et au cacao',
      'nutriscore_grade': 'e',
      'nova_group': 4,
      'categories_tags': ['fr:pates-a-tartiner', 'en:spreads'],
      'categories_hierarchy': ['en:spreads', 'fr:pates-a-tartiner'],
      'created_t': 1600000000,
      'last_updated_t': 1650000000,
      'completeness': 0.8,
      'popularity_key': 100,
      'quantity': '400 g',
      'serving_size': '15 g',
      'ingredients_text_with_allergens_fr':
          'Sucre, huile de palme, noisettes 13%, lait écrémé en poudre 8.7%, cacao maigre 7.4%.',
      'nutriments': {
        'energy-kcal_100g': '539',
        'fat_100g': '30.9',
        'sugars_100g': '56.3',
        'proteins_100g': '6.3',
      },
      'nutrient_levels': {
        'fat': 'high',
        'saturated-fat': 'high',
        'sugars': 'high',
        'salt': 'moderate',
      },
      'additives_tags': ['en:e322'],
      'manufacturing_places': 'France',
      'link': 'https://world.openfoodfacts.org/product/3017620422003/nutella',
    },
    {
      'code': '3228857000166',
      'id': '3228857000166',
      'image_front_small_url':
          'https://images.openfoodfacts.org/images/products/322/885/700/0166/front_fr.3.400.jpg',
      'image_front_url':
          'https://images.openfoodfacts.org/images/products/322/885/700/0166/front_fr.3.400.jpg',
      'brands': ['Pain des fleurs'],
      'product_name': 'Tartines craquantes au sarrasin bio',
      'product_name_fr': 'Tartines craquantes au sarrasin bio',
      'nutriscore_grade': 'a',
      'nova_group': 1,
      'categories_tags': ['fr:pain-des-fleurs', 'en:breads'],
      'categories_hierarchy': ['en:breads', 'fr:pain-des-fleurs'],
      'created_t': 1620000000,
      'last_updated_t': 1670000000,
      'completeness': 0.95,
      'popularity_key': 90,
      'quantity': '150 g',
      'serving_size': '15 g',
      'ingredients_text_with_allergens_fr':
          'Farine de sarrasin*, sucre de canne brut*, sel marin.',
      'nutriments': {
        'energy-kcal_100g': '388',
        'fat_100g': '2.8',
        'sugars_100g': '1.8',
        'proteins_100g': '13.0',
      },
      'nutrient_levels': {
        'fat': 'high',
        'saturated-fat': 'high',
        'sugars': 'high',
        'salt': 'moderate',
      },
      'additives_tags': ['en:e330', 'en:e322'],
      'manufacturing_places': 'France',
      'link': 'https://world.openfoodfacts.org/product/3228857000166',
    },
  ];

  @override
  Future<Product> fetchProductById(String id, {bool complete = false}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final json = _fakeProductsJson.firstWhere(
      (p) => p['id'] == id,
      orElse: () => _fakeProductsJson.first,
    );
    return Product.fromJson(json);
  }

  @override
  Future<Map<String, dynamic>> searchProductsByQuery({
    required String query,
    required String sortBy,
    required int page,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'count': _fakeProductsJson.length,
      'page': page,
      'page_size': 20,
      'products': List.generate(
        20,
        (index) => _fakeProductsJson[index % _fakeProductsJson.length],
      ),
    };
  }

  @override
  Future<List<Product>> fetchSuggestedProducts({
    required String id,
    required String brand,
    required String name,
    required List<String> categories,
    required String nutriscore,
    required String nova,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.generate(4, (index) {
      return Product.fromJson(
        _fakeProductsJson[index % _fakeProductsJson.length],
      );
    });
  }

  @override
  Future<List<Product>> fetchLastProducts() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.generate(4, (index) {
      return Product.fromJson(
        _fakeProductsJson[index % _fakeProductsJson.length],
      );
    });
  }
}
