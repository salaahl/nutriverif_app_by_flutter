import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

import 'package:app_nutriverif/providers/products_provider.dart';

import 'package:app_nutriverif/views/widgets/loader.dart';
import 'package:app_nutriverif/views/widgets/product_card/product_card.dart';

class AlternativeProducts extends StatelessWidget {
  final List<dynamic> products;
  final bool animateHero;

  const AlternativeProducts({
    super.key,
    required this.products,
    this.animateHero = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: defaultAnimationTime,
      curve: defaultAnimationCurve,
      child: Selector<ProductsProvider, bool>(
        selector: (_, provider) => provider.suggestedProductsIsLoading,
        builder: (context, isLoading, _) {
          // Cas de figure 1 : les produits sont chargés par le combo service/provider (page product)
          // Cas de figure 2 : les produits sont chargés par le service uniquement (page home)
          final suggestedProducts =
              products.isNotEmpty
                  ? products
                  : context.read<ProductsProvider>().suggestedProducts;

          return Container(
            height: isLoading || suggestedProducts.isNotEmpty ? null : 0,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 32),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                const BoxShadow(
                  color: Color.fromRGBO(255, 255, 255, 0.01),
                  offset: Offset(0, 1),
                  blurRadius: 1,
                  spreadRadius: 0,
                ),
                const BoxShadow(
                  color: Color.fromRGBO(50, 50, 93, 0.025),
                  offset: Offset(0, 50),
                  blurRadius: 100,
                  spreadRadius: -20,
                ),
                const BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.03),
                  offset: Offset(0, 30),
                  blurRadius: 60,
                  spreadRadius: -30,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const WidgetTitle(),
                const SizedBox(height: 16),
                isLoading
                    ? const Loader()
                    : Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: MediaQuery.of(context).size.width / 100 * 4,
                      children:
                          suggestedProducts.map((product) {
                            return ProductCard(
                              product: product,
                              widthAjustment: 32,
                              animate: animateHero,
                            );
                          }).toList(),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class WidgetTitle extends StatelessWidget {
  const WidgetTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          text: "A",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontFamily: 'Grand Hotel',
            color: Colors.redAccent,
          ),
          children: [
            const TextSpan(
              text: "lternatives",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
