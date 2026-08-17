import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

import 'package:app_nutriverif/providers/products_provider.dart';

import 'package:app_nutriverif/views/widgets/loader.dart';
import 'package:app_nutriverif/views/widgets/product_card/product_card.dart';

class AlternativeProducts extends StatefulWidget {
  final bool animate;
  final String isFrom;

  const AlternativeProducts({
    super.key,
    this.animate = false,
    required this.isFrom,
  });

  @override
  State<AlternativeProducts> createState() => _AlternativeProductsState();
}

class _AlternativeProductsState extends State<AlternativeProducts> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductsProvider>();
    final actualWidth = MediaQuery.of(context).size.width;

    return AnimatedSize(
      duration: defaultAnimationTime,
      curve: defaultAnimationCurve,
      child: Selector<ProductsProvider, bool>(
        selector: (_, provider) => provider.suggestedProductsIsLoading,
        builder: (context, isLoading, _) {
          final bool showSuggestedProducts =
              widget.isFrom == 'home'
                  ? provider.showSuggestedProductsDemo
                  : provider.showSuggestedProducts;

          final suggestedProducts =
              widget.isFrom == 'home'
                  ? provider.suggestedProductsDemo
                  : provider.suggestedProducts;

          return Container(
            height:
                isLoading ||
                        suggestedProducts.isNotEmpty ||
                        showSuggestedProducts == false
                    ? null
                    : 0,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 32),
            padding:
                actualWidth > maxWidth
                    ? const EdgeInsets.all(32)
                    : const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  widget.isFrom == 'home'
                      ? const Color.fromRGBO(255, 255, 255, 0.5)
                      : Colors.grey[200],
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
                showSuggestedProducts == false
                    ? Container(
                      margin: const EdgeInsets.only(top: 16),
                      width: double.infinity,
                      child: Tooltip(
                        message: 'Plus de produits',
                        child: Column(
                          children: [
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              spacing:
                                  actualWidth > maxWidth
                                      ? maxWidth / 100 * 4
                                      : actualWidth / 100 * 4,
                              children: [
                                ...List.generate(
                                  4,
                                  (_) => const ProductCard(
                                    product: null,
                                    widthAjustment: 32,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      widget.isFrom == 'home'
                                          ? provider.loadSuggestedProductsDemo()
                                          : provider.loadSuggestedProducts(
                                            id: provider.product.id,
                                            brand: provider.product.brand,
                                            name: provider.product.name,
                                            categories:
                                                provider.product.categories,
                                            nutriscore:
                                                provider.product.nutriscore,
                                            nova: provider.product.nova,
                                          );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      backgroundColor: const Color.fromRGBO(
                                        0,
                                        189,
                                        126,
                                        1,
                                      ),
                                    ),
                                    child: const Text(
                                      'Afficher les produits',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                    : isLoading
                    ? const Loader()
                    : Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing:
                          actualWidth > maxWidth
                              ? maxWidth / 100 * 4
                              : actualWidth / 100 * 4,
                      children:
                          suggestedProducts.map((product) {
                            return ProductCard(
                              product: product,
                              widthAjustment: 32,
                              animate: widget.animate,
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
