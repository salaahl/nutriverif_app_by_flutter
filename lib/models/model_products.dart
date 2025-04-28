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
    this.manufacturingPlace = '',
    this.link = '',
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] ?? json['code'] ?? '').toString(),
      image: (json['image_url'] ?? '').toString(),
      brand: (json['brands'] ?? '').toString(),
      name: (json['generic_name_fr'] ?? '').toString(),
      category: (json['main_category_fr'] ?? '').toString(),
      categories: (json['categories_tags'] as List?)?.cast<String>() ?? [],
      lastUpdate: (json['last_modified_t'] ?? '').toString(),
      nutriscore: (json['nutriscore_grade'] ?? 'unknown').toString(),
      nova: (json['nova_group'] ?? 'unknown').toString(),
      quantity: (json['quantity'] ?? '').toString(),
      servingSize: (json['serving_size'] ?? '').toString(),
      ingredients: (json['ingredients_text_fr'] ?? '').toString(),
      nutriments: Map<String, dynamic>.from(json['nutriments'] ?? {}),
      nutrientLevels: Map<String, dynamic>.from(json['nutrient_levels'] ?? {}),
      manufacturingPlace: (json['manufacturing_places'] ?? '').toString(),
      link: (json['url'] ?? '').toString(),
    );
  }
}
