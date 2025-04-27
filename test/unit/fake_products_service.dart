import 'package:app_nutriverif/models/model_products.dart';

class FakeProductsService {
  final Map<String, dynamic> productData = {
    'id': '1234567890123',
    'image_url': 'https://example.com/fake-image.jpg', // Correspond à 'image'
    'brands': 'Fake Brand', // Correspond à 'brand'
    'generic_name_fr': 'Fake Product', // Correspond à 'name'
    'main_category_fr': 'Snacks', // Correspond à 'category'
    'categories_tags': [
      'Snacks',
      'Sweet snacks',
      'Chocolate products',
    ], // Correspond à 'categories'
    'last_modified_t':
        DateTime.now().millisecondsSinceEpoch
            .toString(), // Correspond à 'lastUpdate'
    'nutriscore_grade': 'd', // Correspond à 'nutriscore'
    'nova_group': '2', // Correspond à 'nova'
    'quantity': '200g',
    'serving_size': '50g',
    'ingredients_text_fr':
        'Sugar, Cocoa Butter, Milk Powder, Cocoa Mass, Emulsifier, Flavoring', // Correspond à 'ingredients'
    'nutriments': {
      'energy_100g': 2200,
      'fat_100g': 30,
      'saturated_fat_100g': 18,
      'sugars_100g': 55,
      'salt_100g': 0.25,
    }, // Correspond à 'nutriments'
    'nutrient_levels': {
      'fat': 'high',
      'saturated-fat': 'high',
      'sugars': 'high',
      'salt': 'moderate',
    }, // Correspond à 'nutrientLevels'
    'manufacturing_places':
        'Fake City, Fake Country', // Correspond à 'manufacturingPlace'
    'url': 'https://example.com/fake-product', // Correspond à 'link'
    'popularity_key': 100,
    'created_t': DateTime.now().millisecondsSinceEpoch,
    'completeness': 0.5,
  };

  Future<Product> fetchProductById(String id) async {
    final data = productData;
    return Product.fromJson(data);
  }

  Future<Map<String, dynamic>> searchProductsByQuery({
    required String query,
    required String sortBy,
    required int page,
  }) async {
    final data = {
      'products': List.generate(8, (index) => Product.fromJson(productData)),
    };
    return data;
  }

  Future<List<Product>> fetchSuggestedProducts({
    required String id,
    required List<String> categories,
    required String nutriscore,
    required String nova,
  }) async {
    final data = {
      'products': List.generate(8, (index) {
        Map<String, dynamic> product = Map.from(productData);

        switch (index) {
          // 3ème place
          case 0:
            product['generic_name_fr'] = 'Third product';
            product['nutriscore'] = 'b';
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
          // Ne doit pas ressortir car son nutriscore est plus faible que le produit concerné
          case 3:
            product['nutriscore'] = 'e';
            break;
          // Ne doit pas ressortir malgré son nutriscore "a" car completeness < 0.35
          case 5:
            product['generic_name_fr'] = 'Bad product';
            product['nutriscore'] = 'a';
            product['completeness'] = 0.25;
            break;
          // en 3è place
          case 6:
            product['nutriscore'] = 'a';
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

    const score = ['a', 'b', 'c', 'd', 'e'];

    final productsList = data['products'] as List<dynamic>;

    /* Critères :
      * - de sélection : nutriscore > nova > popularité
      * - éliminatoires : pas de nutriscore et/ou completeness < 0.35
    */
    final selected =
        productsList.where((e) {
            final eNutriscore = e['nutriscore_grade'];
            final eNova = e['nova_group'];
            final completeness = e['completeness'];
            final eId = e['id'] ?? e['code'];

            if (eId == null || eId == id) return false;

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

            if (scoreDiff < 0) return true;
            if (scoreDiff == 0 && bothNovaOk && eNovaParsed < pNovaParsed) {
              return true;
            }

            if (completeness is double && completeness >= 0.35) return true;

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

    return selected.take(4).map((p) => Product.fromJson(p)).toList();
  }

  Future<List<Product>> fetchLastProducts() async {
    final data = {
      'products': List.generate(4, (index) {
        Map<String, dynamic> product = Map.from(productData);

        switch (index) {
          case 0:
            product['generic_name_fr'] = 'Second product';
            product['created_t'] = DateTime(2023, 12, 1).millisecondsSinceEpoch;
            break;
          // Completeness trop faible pour être inclus
          case 2:
            product['generic_name_fr'] = 'Bad product';
            product['created_t'] = DateTime(2024, 1, 1).millisecondsSinceEpoch;
            product['completeness'] = 0.25;
            break;
          // 1er
          case 3:
            product['generic_name_fr'] = 'Best product';
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
}
