// models.dart
class Products {
  final String id;
  final String image;
  final String brand;
  final String name;
  final String nutriscore;
  final dynamic nova; // Peut être un String ou un int

  Products({
    required this.id,
    required this.image,
    required this.brand,
    required this.name,
    required this.nutriscore,
    required this.nova,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: (json['id'] ?? '').toString(),
      image: (json['image_front_small_url'] ?? '').toString(),
      brand: (json['brands'] ?? '').toString(),
      name: (json['generic_name_fr'] ?? '').toString(),
      nutriscore: (json['nutriscore_grade'] ?? 'unknown').toString(),
      nova: (json['nova_group'] ?? 'unknown').toString(),
    );
  }
}

class Product {
  final String id;
  final String image;
  final String brand;
  final String genericName;
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
    required this.genericName,
    required this.category,
    required this.categories,
    required this.lastUpdate,
    required this.nutriscore,
    required this.nova,
    required this.quantity,
    required this.servingSize,
    required this.ingredients,
    required this.nutriments,
    required this.nutrientLevels,
    required this.manufacturingPlace,
    required this.link,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['_id'] ?? '').toString(),
      image: (json['image_url'] ?? '').toString(),
      brand: (json['brands'] ?? '').toString(),
      genericName: (json['generic_name_fr'] ?? '').toString(),
      category: (json['main_category_fr'] ?? '').toString(),
      categories:
          (json['categories_tags'] as List?)
              ?.map((e) => e.split(':')[1].toString().replaceAll('-', ' '))
              .toList() ??
          [],
      lastUpdate: (json['last_modified_t'] ?? '').toString(),
      nutriscore: (json['nutriscore_grade'] ?? '').toString(),
      nova: (json['nova_group'] ?? '').toString(),
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
