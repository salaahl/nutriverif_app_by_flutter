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
        expect(provider.product.name, 'Pâte à tartiner aux noisettes et au cacao');
        expect(provider.product.brand, 'Nutella');
        expect(provider.product.nutriscore, 'd');
        expect(provider.productIsLoading, false);
      },
    );

    test(
      's\'assurer que l\'appel de loadSuggestedProducts initialise bien la variable suggestedProducts',
      () async {
        await provider.loadSuggestedProducts(
          id: '3608580758686',
          brand: 'Marque de chocolat',
          name: 'Barre de chocolat',
          categories: ['fr:pates-a-tartiner', 'en:Snacks'],
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
        expect(provider.lastProducts[0].name, 'Most recent product');
        expect(provider.lastProducts[1].name, 'Second most ancient product');
      },
    );

    test(
      's\'assurer que l\'appel de getTranslatedCategories traite correctement les categories',
      () async {
        final categories = [
          'fr:Snacks',
          'fr:Desserts',
          'fr:Produits au chocolat',
          'en:Snacks',
          'en:Desserts',
          'en:Chocolate products',
        ];
        final translatedCategories = await provider.getTranslatedCategories(
          categories,
        );

        expect(translatedCategories, hasLength(4));
        expect(translatedCategories[0]['translated'], 'Snacks');
        expect(translatedCategories[1]['translated'], 'Desserts');
        expect(translatedCategories[2]['translated'], 'Produits au chocolat');
        expect(
          translatedCategories[3]['translated'],
          'Bonjour',
        ); // Texte retourné par le service de traduction
      },
    );
  });
}
