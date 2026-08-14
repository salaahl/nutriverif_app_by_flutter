class Product {
  final String id;
  final String image;
  final String brand;
  final String name;
  final String category;
  final List<String> categories;
  final String lastUpdate;
  final String nutriscore;
  final String nova;
  final String quantity;
  final String servingSize;
  final String ingredients;
  final Map<String, dynamic> nutriments;
  final Map<String, dynamic> nutrientLevels;
  final List<String> additives;
  final String manufacturingPlace;
  final String link;

  Product({
    required this.id,
    required this.image,
    required this.brand,
    required this.name,
    this.category = '',
    this.categories = const [],
    this.lastUpdate = '',
    required this.nutriscore,
    required this.nova,
    this.quantity = '',
    this.servingSize = '',
    this.ingredients = '',
    this.nutriments = const {},
    this.nutrientLevels = const {},
    this.additives = const [],
    this.manufacturingPlace = '',
    this.link = '',
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Si la réponse wrap le produit sous 'product' (ex: API v3)
    final Map<String, dynamic> data =
        json.containsKey('product') && json['product'] is Map<String, dynamic>
            ? json['product']
            : json;
    return Product(
      id: (data['id'] ?? data['code'] ?? '').toString(),
      image:
          (data['image_url'] ??
                  data['image_front_url'] ??
                  data['image_front_small_url'] ??
                  '')
              .toString(),
      brand:
          data['brands'] is List
              ? (data['brands'] as List).join(', ')
              : (data['brands'] ?? '').toString(),
      name:
          (data['generic_name_fr'] ??
                  data['product_name_fr'] ??
                  data['product_name'] ??
                  '')
              .toString(),
      category:
          (data['main_category_fr'] ?? data['compared_to_category'] ?? '')
              .toString(),
      categories:
          (data['categories_tags'] as List?)?.cast<String>() ??
          (data['categories_hierarchy'] as List?)?.cast<String>() ??
          [],
      lastUpdate:
          (data['last_modified_t'] ?? data['last_updated_t'] ?? '').toString(),
      nutriscore: (data['nutriscore_grade'] ?? 'unknown').toString(),
      nova: (data['nova_group'] ?? 'unknown').toString(),
      quantity: (data['quantity'] ?? '').toString(),
      servingSize: (data['serving_size'] ?? '').toString(),
      ingredients:
          (data['ingredients_text_fr'] ??
                  data['ingredients_text_with_allergens_fr'] ??
                  '')
              .toString(),

      nutriments: Map<String, dynamic>.from(data['nutriments'] ?? {}),
      nutrientLevels:
          data['nutrient_levels'] is Map
              ? Map<String, dynamic>.from(data['nutrient_levels'])
              : {},
      additives: (data['additives_tags'] as List?)?.cast<String>() ?? [],
      manufacturingPlace: (data['manufacturing_places'] ?? '').toString(),
      link: (data['url'] ?? data['link'] ?? '').toString(),
    );
  }
}
