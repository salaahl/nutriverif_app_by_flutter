import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/model_products.dart';

class ProductsService {
  static const String _api2BaseUrl =
      'https://world.openfoodfacts.org/api/v2/search';

  static const String _api3BaseUrl = 'https://world.openfoodfacts.org/api/v3';

  static const String _productFields =
      'id,image_url,brands,generic_name_fr,main_category_fr,categories_tags,created_t,last_modified_t,nutriscore_grade,nova_group,quantity,serving_size,ingredients_text_fr,nutriments,nutrient_levels,manufacturing_places,url,completeness,popularity_key';

  static const String _productsFields =
      'id,image_url,brands,generic_name_fr,categories_tags,created_t,nutriscore_grade,nova_group,compared_to_category,completeness,popularity_key';

  Future<Map<String, dynamic>> _getJson(String url) async {
    final response = await http
        .get(Uri.parse(url))
        .timeout(Duration(seconds: 45));
    if (response.statusCode != 200) throw Exception('API error');
    return jsonDecode(response.body);
  }

  Future<Product> fetchProductById(String id) async {
    final url = '$_api3BaseUrl/product/$id?fields=$_productFields';

    try {
      final data = await _getJson(url);
      return Product.fromJson(data['product']);
    } catch (e) {
      return Product.fromJson({});
    }
  }

  Future<Map<String, dynamic>> searchProductsByQuery({
    required String query,
    required String sortBy,
    required int page,
  }) async {
    final url =
        'https://world.openfoodfacts.org/cgi/search.pl?search_terms=${Uri.encodeComponent(query)}&fields=${Uri.encodeComponent(_productsFields)}&purchase_places_tags=france&sort_by=${Uri.encodeComponent(sortBy)}&page_size=20&page=$page&search_simple=1&action=process&json=1';

    try {
      final data = await _getJson(url);
      return data;
    } catch (e) {
      return {};
    }
  }

  Future<List<Product>> fetchSuggestedProducts({
    required String id,
    required List<String> categories,
    required String nutriscore,
    required String nova,
  }) async {
    final url =
        '$_api2BaseUrl?categories_tags=${Uri.encodeComponent(categories.last)}&fields=${Uri.encodeComponent(_productsFields)}&purchase_places_tags=france&sort_by=nutriscore_score,nova_group,popularity_key&page_size=300&action=process&json=1';

    try {
      final data = await _getJson(url);

      const score = ['a', 'b', 'c', 'd', 'e'];

      /* Critères :
      * - de sélection : nutriscore > nova > pertinence
      * - éliminatoires : pas de nutriscore et/ou completeness < 0.35
    */
      final selected =
          (data['products'] as List).where((e) {
              final eNutriscore = e['nutriscore_grade'];
              final eNova = e['nova_group'];
              final completeness = e['completeness'];
              final eId = e['id'] ?? e['code'];

              // 🔵 Application des filtres

              // 1.  Critères éliminatoires : éliminer s'il s'agit du produit actuellement affiché
              if (eId == null || eId == id) return false;

              // 2. Critères éliminatoires : nutriscore absent ou inconnu
              if (!score.contains(eNutriscore) || !score.contains(nutriscore)) {
                return false;
              }

              // 3. Critères éliminatoires : completeness inférieur à 0.35
              if (completeness is! double || completeness < 0.35) {
                return false;
              }

              // 4. Comparaison entre le nutriscore du produit et celui du produit de base
              final eScoreIndex = score.indexOf(eNutriscore);
              final pScoreIndex = score.indexOf(nutriscore);
              final scoreDiff = eScoreIndex.compareTo(pScoreIndex);

              final eNovaParsed = num.tryParse(eNova.toString());
              final pNovaParsed = num.tryParse(nova);
              final bothNovaOk =
                  eNovaParsed != null &&
                  pNovaParsed != null; // doit renvoyer true

              // 5. Sélection par priorité :
              // - Un meilleur nutriscore passe
              if (scoreDiff < 0) return true;

              // - Si nutriscore égal, vérifier la nova : une meilleure nova passe
              if (scoreDiff == 0 && bothNovaOk && eNovaParsed < pNovaParsed) {
                return true;
              }

              // 🔵 7. Sinon, le produit n'est pas sélectionné
              return false;
            }).toList()
            ..sort((a, b) {
              // 🟢 Tri final des produits sélectionnés

              // 1. Priorité sur le nutriscore (meilleur d'abord)
              final aScore = score.indexOf(a['nutriscore_grade']);
              final bScore = score.indexOf(b['nutriscore_grade']);
              final scoreComp = aScore.compareTo(bScore);
              if (scoreComp != 0) return scoreComp;

              // 2. Si nutriscore égal, priorité sur le nova
              final aNova = num.tryParse(a['nova_group'].toString());
              final bNova = num.tryParse(b['nova_group'].toString());
              if (aNova != null && bNova != null) {
                final novaComp = (aNova - bNova).toInt();
                if (novaComp != 0) return novaComp;
              }

              // 3. Si nutriscore et nova égaux, priorité sur la pertinence
              final aPop = a['popularity_key'];
              final bPop = b['popularity_key'];
              if (aPop is int && bPop is int) {
                return bPop - aPop;
              }

              // 4. Sinon, égalité
              return 0;
            });

      return selected.take(4).map((p) => Product.fromJson(p)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Product>> fetchLastProducts() async {
    final url =
        '$_api2BaseUrl?&fields=${Uri.encodeComponent(_productsFields)}&purchase_places_tags=france&sort_by=created_t&page_size=300&action=process&json=1';

    try {
      final data = await _getJson(url);

      final filtered =
          (data['products'] as List)
              .where((p) => (p['completeness'] as num).toDouble() >= 0.35)
              .toList()
            ..sort(
              (a, b) =>
                  (b['created_t'] as num).compareTo((a['created_t'] as num)),
            );

      return filtered.take(4).map((p) => Product.fromJson(p)).toList();
    } catch (e) {
      return [];
    }
  }
}
