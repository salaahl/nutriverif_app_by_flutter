import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import './fake_products_service.dart';

class MockProductsService extends Mock implements FakeProductsService {}

void main() {
  group('ProductsService', () {
    late FakeProductsService service;

    setUp(() {
      service = FakeProductsService();
    });

    test(
      's\'assurer que l\'appel de fetchProductById initialise bien la variable product',
      () async {
        final product = await service.fetchProductById('3608580758686');

        expect(product.name, isNotEmpty);
        expect(product.brand, isNotEmpty);
        expect(product.nutriscore, isNotEmpty);
      },
    );

    test(
      's\'assurer que l\'appel de fetchSuggestedProducts filtre bien les produits',
      () async {
        final suggestedProducts = await service.fetchSuggestedProducts(
          id: '3608580758686',
          name: 'Barre de chocolat',
          categories: ['Snacks', 'Desserts', 'Chocolate products'],
          nutriscore: 'a',
          nova: '2',
        );

        expect(suggestedProducts, hasLength(1));
        expect(suggestedProducts[0].name, 'Best product');
      },
    );

    test(
      's\'assurer que l\'appel de fetchLastProducts initialise bien la variable lastProduct',
      () async {
        final lastProducts = await service.fetchLastProducts();

        expect(lastProducts, hasLength(3));
        expect(lastProducts[0].name, 'Best product');
      },
    );
  });
}
