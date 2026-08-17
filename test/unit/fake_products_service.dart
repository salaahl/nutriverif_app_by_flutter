import 'package:app_nutriverif/models/model_products.dart';

class FakeProductsService {
  final Map<String, dynamic> _productData = {
    'code': '3017620422003',
    'id': '3017620422003',
    'image_front_small_url':
        'https://images.openfoodfacts.org/images/products/301/762/042/2003/front_fr.429.400.jpg',
    'image_front_url':
        'https://images.openfoodfacts.org/images/products/301/762/042/2003/front_fr.429.400.jpg',
    'brands': ['Nutella'],
    'product_name': 'Pâte à tartiner aux noisettes et au cacao',
    'product_name_fr': 'Pâte à tartiner aux noisettes et au cacao',
    'nutriscore_grade': 'd',
    'nova_group': 2,
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
  };

  Future<Product> fetchProductById(String id, {bool complete = false}) async {
    final data = _productData;
    return Product.fromJson(data);
  }

  Future<Map<String, dynamic>> searchProductsByQuery({
    required String query,
    required String sortBy,
    required int page,
  }) async {
    final data = {
      'products': List.generate(8, (index) => Product.fromJson(_productData)),
    };
    return data;
  }

  Future<List<Product>> fetchLastProducts() async {
    final data = {
      'products': List.generate(4, (index) {
        Map<String, dynamic> product = Map.from(_productData);

        switch (index) {
          case 0:
            product['generic_name_fr'] = 'Second most ancient product';
            product['created_t'] = DateTime(2023, 12, 1).millisecondsSinceEpoch;
            break;
          // Completeness trop faible pour être récupéré
          case 2:
            product['generic_name_fr'] =
                'Most ancient product but completeness too low';
            product['created_t'] = DateTime(2024, 1, 1).millisecondsSinceEpoch;
            product['completeness'] = 0.25;
            break;
          // 1er
          case 3:
            product['generic_name_fr'] = 'Most recent product';
            product['created_t'] = DateTime(2025, 1, 1).millisecondsSinceEpoch;
            break;
          default:
            product['created_t'] = DateTime(2022, 1, 1).millisecondsSinceEpoch;
            product['completeness'] = 0.5;
        }

        return product;
      }),
    };

    final productsList = data['products'] as List<dynamic>;

    // Filtrer les produits dont completeness >= 0.35 puis trier par date
    final filtered =
        productsList
            .where((p) => (p['completeness'] as num? ?? 1.0) >= 0.35)
            .toList()
          ..sort(
            (a, b) =>
                (b['created_t'] as num).compareTo((a['created_t'] as num)),
          );

    // Retourner les produits après filtrage et tri
    return filtered.take(4).map((p) => Product.fromJson(p)).toList();
  }

  Future<List<Product>> fetchSuggestedProducts({
    required String id,
    required String brand,
    required String name,
    required List<String> categories,
    required String nutriscore,
    required String nova,
  }) async {
    final effectiveNutriscore =
        (nutriscore == 'unknown' || nutriscore.isEmpty) ? 'e' : nutriscore;
    final effectiveNova = (nova == 'unknown' || nova.isEmpty) ? '4' : nova;

    final data = {
      'hits': List.generate(8, (index) {
        Map<String, dynamic> product = Map.from(_productData);

        switch (index) {
          // 3ème place
          case 0:
            product['generic_name_fr'] = 'Third product';
            product['nutriscore_grade'] = 'b';
            break;
          // 2ème place
          case 1:
            product['generic_name_fr'] = 'Second product';
            product['nutriscore_grade'] = 'a';
            product['nova_group'] = '2';
            product['completeness'] = 0.5;
            product['popularity_key'] = 999;
            break;
          // 1ère place
          case 2:
            product['generic_name_fr'] = 'Best product';
            product['nutriscore_grade'] = 'a';
            product['nova_group'] = '1';
            product['completeness'] = 0.5;
            product['popularity_key'] = 990;
            break;
          // Ne doit pas ressortir car son nutriscore est plus faible que celui du produit concerné
          case 3:
            product['nutriscore'] = 'e';
            break;
          // Ne doit pas ressortir malgré son nutriscore "a" car completeness < 0.35
          case 5:
            product['generic_name_fr'] = 'Bad product';
            product['nutriscore_grade'] = 'a';
            product['completeness'] = 0.25;
            break;
          // en 3è place
          case 6:
            product['nutriscore_grade'] = 'a';
            product['nova_group'] = '4';
            product['completeness'] = 0.5;
            product['popularity_key'] = 359;
            break;
          default:
            product['nutriscore'] = 'unknown';
        }

        return product;
      }),
    };

    try {
      final List hits = data['hits'] ?? [];

      const scoreOrder = ['a', 'b', 'c', 'd', 'e'];
      final specificCategories =
          categories.length >= 2
              ? categories.sublist(categories.length - 2)
              : categories;

      final filteredHits =
          hits.where((e) {
            final productCode = (e['code'] ?? e['id'])?.toString();
            if (productCode == id) return false;

            var itemNutriscore = e['nutriscore_grade']?.toString();
            if (itemNutriscore == null ||
                itemNutriscore == 'not-applicable' ||
                itemNutriscore == 'unknown') {
              itemNutriscore = effectiveNutriscore;
            }

            final itemNova = num.tryParse(e['nova_group']?.toString() ?? '');
            final targetNova = num.tryParse(effectiveNova);

            final itemTags =
                (e['categories_tags'] as List?)?.cast<String>() ??
                (e['categories_hierarchy'] as List?)?.cast<String>() ??
                [];

            final currentScoreIndex = scoreOrder.indexOf(itemNutriscore);
            final targetScoreIndex = scoreOrder.indexOf(effectiveNutriscore);

            final isBetterNutriscore =
                currentScoreIndex != -1 &&
                targetScoreIndex != -1 &&
                currentScoreIndex < targetScoreIndex;

            final isEqualNutriscoreBetterNova =
                currentScoreIndex == targetScoreIndex &&
                itemNova != null &&
                targetNova != null &&
                itemNova < targetNova;

            final matchesCategory =
                specificCategories.isEmpty ||
                itemTags.any((tag) => specificCategories.contains(tag));

            return (isBetterNutriscore || isEqualNutriscoreBetterNova) &&
                matchesCategory;
          }).toList();

      filteredHits.sort((a, b) {
        final aScore = scoreOrder.indexOf(
          a['nutriscore_grade']?.toString() ?? 'e',
        );
        final bScore = scoreOrder.indexOf(
          b['nutriscore_grade']?.toString() ?? 'e',
        );
        if (aScore != bScore) return aScore.compareTo(bScore);

        final aNova = num.tryParse(a['nova_group']?.toString() ?? '') ?? 4;
        final bNova = num.tryParse(b['nova_group']?.toString() ?? '') ?? 4;
        if (aNova != bNova) return aNova.compareTo(bNova);

        final aPop = (a['popularity_key'] as num?)?.toInt() ?? 0;
        final bPop = (b['popularity_key'] as num?)?.toInt() ?? 0;
        return bPop.compareTo(aPop);
      });

      return filteredHits.take(4).map((p) => Product.fromJson(p)).toList();
    } catch (e) {
      return [];
    }
  }
}
