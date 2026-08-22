import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

import 'package:app_nutriverif/providers/products_provider.dart';

import 'package:app_nutriverif/views/widgets/loader.dart';
import 'package:app_nutriverif/views/widgets/product_card/product_card.dart';

class SearchProductsResults extends StatelessWidget {
  const SearchProductsResults({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductsProvider>();
    final actualWidth = MediaQuery.of(context).size.width;

    return AnimatedSize(
      duration: defaultAnimationTime,
      curve: defaultAnimationCurve,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          children: [
            Container(
              height:
                  provider.productsIsLoading || provider.products.isNotEmpty
                      ? null
                      : 0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child:
                  provider.productsIsLoading
                      ? const Loader()
                      : Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        spacing:
                            actualWidth > maxWidth
                                ? actualWidth / 100 * 2
                                : actualWidth / 100 * 4,
                        children:
                            provider.products
                                .take(actualWidth > maxWidth ? 3 : 4)
                                .map((product) {
                                  return ProductCard(
                                    product: product,
                                    widthAjustment: 32,
                                    animate: false,
                                  );
                                })
                                .toList(),
                      ),
            ),
            if (provider.products.length > 3)
              Container(
                margin: const EdgeInsets.only(top: 16),
                width: double.infinity,
                child: Tooltip(
                  message: 'Plus de produits',
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/products');
                    },
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: const Color.fromRGBO(0, 189, 126, 1),
                    ),
                    child: const Icon(Icons.add, size: 24, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
