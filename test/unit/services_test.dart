import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app_nutriverif/models/model_products.dart';
import 'package:app_nutriverif/core/services/products_service.dart';

class MockProductsService extends Mock implements ProductsService {}

void main() {
  group('ProductsService', () {
    late ProductsService service;
    late MockProductsService mockService;
    final productData = {
      'id': '1234567890123',
      'image': 'https://example.com/fake-image.jpg',
      'brand': 'Fake Brand',
      'name': 'Fake Product',
      'category': 'Snacks',
      'categories': ['Snacks', 'Sweet snacks', 'Chocolate products'],
      'lastUpdate': DateTime.now().millisecondsSinceEpoch.toString(),
      'nutriscore': 'b',
      'nova': '2',
      'quantity': '200g',
      'servingSize': '50g',
      'ingredients':
          'Sugar, Cocoa Butter, Milk Powder, Cocoa Mass, Emulsifier, Flavoring',
      'nutriments': {
        'energy_100g': 2200,
        'fat_100g': 30,
        'saturated_fat_100g': 18,
        'sugars_100g': 55,
        'salt_100g': 0.25,
      },
      'nutrientLevels': {
        'fat': 'high',
        'saturated-fat': 'high',
        'sugars': 'high',
        'salt': 'moderate',
      },
      'manufacturingPlace': 'Fake City, Fake Country',
      'link': 'https://example.com/fake-product',
    };

    setUp(() {
      mockService = MockProductsService();
      service = ProductsService();
    });

    test(
      's\'assurer que l\'appel de fetchProductById initialise bien la variable product',
      () async {
        when(
          () => mockService.fetchProductById('3608580758686'),
        ).thenAnswer((_) async => Product.fromJson(productData));

        // Appel de ma méthode simulée
        final product = await service.fetchProductById('3608580758686');

        expect(product.name, isNotEmpty);
        expect(product.brand, isNotEmpty);
        expect(product.nutriscore, isNotEmpty);
      },
    );

    test(
      's\'assurer que l\'appel de fetchSuggestedProducts initialise bien la variable suggestedProducts',
      () async {
        when(
          () => mockService.fetchSuggestedProducts(
            id: productData['id'] as String,
            categories: productData['categories'] as List<String>,
            nutriscore: productData['nutriscore'] as String,
            nova: productData['nova'] as String,
          ),
        ).thenAnswer(
          (_) async =>
              List.generate(4, (index) => Product.fromJson(productData)),
        );

        final suggestedProducts = await service.fetchSuggestedProducts(
          id: productData['id'] as String,
          categories: productData['categories'] as List<String>,
          nutriscore: productData['nutriscore'] as String,
          nova: productData['nova'] as String,
        );

        expect(suggestedProducts, hasLength(4));
      },
    );

    test(
      's\'assurer que l\'appel de fetchLastProducts initialise bien la variable lastProduct',
      () async {
        when(() => mockService.fetchLastProducts()).thenAnswer(
          (_) async =>
              List.generate(4, (index) => Product.fromJson(productData)),
        );

        final lastProducts = await service.fetchLastProducts();

        expect(lastProducts, hasLength(4));
      },
    );
  });
}
