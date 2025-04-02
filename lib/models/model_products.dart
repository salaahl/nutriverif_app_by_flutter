// models.dart
class Products {
  final String id;
  final String image;
  final String brand;
  final String name;
  final String nutriscore;
  final dynamic nova; // Peut être String ou int

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
      id: json['id'] ?? '',
      image: json['image_front_small_url'] ?? 'assets/images/logo.png',
      brand: json['brands'] ?? '',
      name: json['generic_name_fr'] ?? '',
      nutriscore: json['nutriscore_grade'] ?? 'unknown',
      nova: json['nova_group'] ?? 'unknown',
    );
  }
}

class Product {
  String id;
  String image;
  String brand;
  String genericName;
  String category;
  List<String> categories;
  String lastUpdate;
  String nutriscore;
  dynamic nova;
  String quantity;
  String servingSize;
  String ingredients;
  Map<String, String> nutriments;
  String nutrientLevels;
  String manufacturingPlace;
  String link;

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
      id: json['id'] ?? '',
      image: json['image_front_url'] ?? 'assets/images/logo.png',
      brand: json['brands'] ?? '',
      genericName: json['generic_name_fr'] ?? '',
      category: json['compared_to_category'] ?? '',
      categories: (json['categories'] as String?)?.split(',') ?? [],
      lastUpdate:
          json['last_updated_t'] != null
              ? DateTime.fromMillisecondsSinceEpoch(
                json['last_updated_t'] * 1000,
              ).toString()
              : '',
      nutriscore: json['nutriscore_grade'] ?? 'unknown',
      nova: json['nova_group'] ?? 'unknown',
      quantity: json['quantity'] ?? '',
      servingSize: json['serving_size'] ?? '',
      ingredients: json['ingredients_text_with_allergens_fr'] ?? '',
      nutriments: Map<String, String>.from(json['nutriments'] ?? {}),
      nutrientLevels: json['nutrient_levels'] ?? '',
      manufacturingPlace: json['manufacturing_places'] ?? '',
      link: json['link'] ?? '',
    );
  }
}
