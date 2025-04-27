import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app_nutriverif/models/model_products.dart';
import 'package:app_nutriverif/providers/products_provider.dart';

class MockProductsProvider extends Mock implements ProductsProvider {}

void main() {
  group('ProductsProvider', () {
    late ProductsProvider provider;
    late MockProductsProvider mockProvider;
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
      // Initialisation du mock avant chaque test
      mockProvider = MockProductsProvider();
      provider = ProductsProvider();
    });

    test(
      's\'assurer que l\'appel de loadProductById initialise bien la variable product',
      () async {
        // Réponse qui sera envoyée par le mock
        when(
          () => mockProvider.loadProductById('3608580758686'),
        ).thenAnswer((_) async => Product.fromJson(productData));

        // Appel de ma méthode simulée
        await provider.loadProductById('3608580758686');

        // S\'assurer que le produit a été initialisé correctement et que le loader est maintenant inactif
        expect(provider.product.name, isNotEmpty);
        expect(provider.product.brand, isNotEmpty);
        expect(provider.product.nutriscore, isNotEmpty);
        expect(provider.productIsLoading, false);
      },
    );

    test(
      's\'assurer que l\'appel de loadSuggestedProducts initialise bien la variable suggestedProducts',
      () async {
        when(
          () => mockProvider.loadSuggestedProducts(
            id: productData['id'] as String,
            categories: productData['categories'] as List<String>,
            nutriscore: productData['nutriscore'] as String,
            nova: productData['nova'] as String,
          ),
        ).thenAnswer(
          (_) async => provider.setSuggestedProducts(
            List.generate(4, (index) => Product.fromJson(productData)),
          ),
        );

        await provider.loadSuggestedProducts(
          id: productData['id'] as String,
          categories: productData['categories'] as List<String>,
          nutriscore: productData['nutriscore'] as String,
          nova: productData['nova'] as String,
        );

        // S\'assurer que le produit a été initialisé correctement et que le loader est maintenant inactif
        expect(provider.suggestedProducts, hasLength(4));
        expect(provider.suggestedProductsIsLoading, false);
      },
    );

    test(
      's\'assurer que l\'appel de loadLastProducts initialise bien la variable lastProduct',
      () async {
        when(() => mockProvider.loadLastProducts()).thenAnswer(
          (_) async =>
              List.generate(4, (index) => Product.fromJson(productData)),
        );

        await provider.loadLastProducts();

        // S\'assurer que le produit a été initialisé correctement et que le loader est maintenant inactif
        expect(provider.lastProducts, hasLength(4));
        expect(provider.lastProductsIsLoading, false);
      },
    );
  });
}
