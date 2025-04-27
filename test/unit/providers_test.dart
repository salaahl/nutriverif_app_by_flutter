import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import './fake_products_provider.dart';

class MockProductsProvider extends Mock implements FakeProductsProvider {}

void main() {
  group('ProductsProvider', () {
    late FakeProductsProvider provider;

    setUp(() {
      // Initialisation du mock avant chaque test
      provider = FakeProductsProvider();
    });

    test(
      's\'assurer que l\'appel de loadProductById initialise bien la variable product',
      () async {
        await provider.loadProductById('3608580758686');

        // S\'assurer que le produit a été initialisé correctement et que le loader est maintenant inactif
        expect(provider.product.name, 'Fake Product');
        expect(provider.product.brand, 'Fake Brand');
        expect(provider.product.nutriscore, 'd');
        expect(provider.productIsLoading, false);
      },
    );

    test(
      's\'assurer que l\'appel de loadSuggestedProducts initialise bien la variable suggestedProducts',
      () async {
        await provider.loadSuggestedProducts(
          id: '3608580758686',
          categories: ['Snacks', 'Desserts', 'Chocolate products'],
          nutriscore: 'b',
          nova: '2',
        );

        expect(provider.suggestedProducts, hasLength(4));
        expect(provider.suggestedProducts[0].name, 'Best product');
      },
    );

    test(
      's\'assurer que l\'appel de loadLastProducts initialise bien la variable lastProduct',
      () async {
        await provider.loadLastProducts();

        expect(provider.lastProducts, hasLength(3));
        expect(provider.lastProducts[0].name, 'Best product');
      },
    );
  });
}
