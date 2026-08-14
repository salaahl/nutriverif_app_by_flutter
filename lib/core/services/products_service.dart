import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/model_products.dart';

class ProductsService {
  static const String _api3BaseUrl = 'https://world.openfoodfacts.org/api/v3';
  static const String _api4BaseUrl = 'https://search.openfoodfacts.org/search';

  static const Map<String, String> _headers = {
    'User-Agent': 'NutriVerif App/2.0 (sokhona.salaha@gmail.com)',
  };

  Future<Map<String, dynamic>> _getJson(String url) async {
    final response = await http
        .get(Uri.parse(url), headers: _headers)
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Erreur HTTP ${response.statusCode}');
    }
    return jsonDecode(response.body);
  }

  String _cleanProductTitle(String name) {
    if (name.isEmpty) return '';
    String cleaned = name.trim();

    final percentRegex = RegExp(r'\d+(?:[.,]\d+)?\s*%');
    final marketingStopWords = RegExp(
      r'(?:\s|^)(extra|supérieur|superieur|authentique|traditionnel|traditionnelle|artisanal|artisanale|sélection|selection|premium|gourmand|gourmande|allégé|allégée|allege|allegee|léger|leger|légère|legere|light|minceur|pur|pure|naturel|naturelle|naturels|naturelles|organic|nouveau|nouvelle|excellence|prestige)(?:\s|$)',
      caseSensitive: false,
    );
    final startRegex = RegExp(
      r'^(le|la|les|un|une|des|du|de|a|à|au|aux|en)(?:\s|$)|^(l|d)[\x27\u2019]\s*',
      caseSensitive: false,
    );
    final endRegex = RegExp(
      r'(?:\s|^)(le|la|les|un|une|des|du|de|a|à|au|aux|en)$|\s*[\x27\u2019](l|d)$',
      caseSensitive: false,
    );

    String previous;
    do {
      previous = cleaned;
      cleaned =
          cleaned
              .replaceAll(percentRegex, ' ')
              .replaceAll(marketingStopWords, ' ')
              .replaceAll(startRegex, '')
              .replaceAll(endRegex, '')
              .replaceAll(RegExp(r'\s+'), ' ')
              .trim();
    } while (cleaned != previous);

    return cleaned;
  }

  Future<Product> fetchProductById(String id, {bool complete = false}) async {
    const fields =
        'id,image_front_url,brands,product_name_fr,categories_hierarchy,last_updated_t,nutriscore_grade,nova_group,quantity,serving_size,ingredients_text_with_allergens_fr,nutriments,nutrient_levels,additives_tags,manufacturing_places,link';
    final url = '$_api3BaseUrl/product/$id?fields=$fields&json=1';

    try {
      final data = await _getJson(url);
      return Product.fromJson(data);
    } catch (e) {
      return Product.fromJson({});
    }
  }

  Future<Map<String, dynamic>> searchProductsByQuery({
    required String query,
    required String sortBy,
    required int page,
  }) async {
    const fields =
        'code,image_front_small_url,brands,product_name,nutriscore_grade,nova_group,categories_tags';
    final queryField =
        (query.startsWith('fr:') || query.startsWith('en:'))
            ? 'categories_tags'
            : 'product_name.fr';

    final sort = sortBy.isNotEmpty ? sortBy : '-popularity_key';
    final qParam =
        '$queryField:"$query" AND countries_tags:"en:france" AND states_tags:"en:brands-completed" AND states_tags:"en:product-name-completed" AND states_tags:"en:photos-uploaded"';

    final uri = Uri.parse(_api4BaseUrl).replace(
      queryParameters: {
        'q': qParam,
        'langs': 'fr',
        'fields': fields,
        'page_size': '20',
        'page': page.toString(),
        'sort_by': sort,
      },
    );

    try {
      return await _getJson(uri.toString());
    } catch (e) {
      return {};
    }
  }

  Future<List<Product>> fetchLastProducts() async {
    const fields =
        'code,image_front_small_url,brands,product_name,nutriscore_grade,nova_group,categories_tags,created_t';
    const qParam =
        'countries_tags:"en:france" AND states_tags:"en:brands-completed" AND states_tags:"en:product-name-completed" AND states_tags:"en:photos-uploaded"';

    final uri = Uri.parse(_api4BaseUrl).replace(
      queryParameters: {
        'q': qParam,
        'fields': fields,
        'sort_by': '-created_t',
        'page_size': '4',
      },
    );

    try {
      final data = await _getJson(uri.toString());
      final List hits = data['hits'] ?? [];
      return hits.take(4).map((p) => Product.fromJson(p)).toList();
    } catch (e) {
      return [];
    }
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

    final cleanedName = _cleanProductTitle(
      name.trim().split(RegExp(r'\s+')).take(5).join(' '),
    );
    final searchTerm =
        cleanedName.isNotEmpty
            ? cleanedName
            : (categories.isNotEmpty ? categories.first : '');

    const fields =
        'code,image_front_small_url,brands,product_name,nutriscore_grade,nova_group,categories_tags,popularity_key';
    final qParam =
        'product_name.fr:"$searchTerm" AND countries_tags:"en:france" AND states_tags:"en:brands-completed" AND states_tags:"en:product-name-completed" AND states_tags:"en:photos-uploaded"';

    final uri = Uri.parse(_api4BaseUrl).replace(
      queryParameters: {
        'q': qParam,
        'langs': 'fr',
        'fields': fields,
        'page_size': '50',
        'sort_by': 'nutriscore_score',
      },
    );

    try {
      final data = await _getJson(uri.toString());
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
