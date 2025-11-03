import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

import 'package:app_nutriverif/providers/products_provider.dart';

import 'package:app_nutriverif/views/widgets/app_container.dart';
import 'package:app_nutriverif/views/widgets/loader.dart';
import 'package:app_nutriverif/views/widgets/product_card/product_card.dart';

class LastProducts extends StatelessWidget {
  const LastProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final actualWidth = MediaQuery.of(context).size.width;

    return AppContainer(
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              text: "Produits",
              children: [
                TextSpan(
                  text: " recemment ",
                  style: TextStyle(color: customGreen),
                ),
                TextSpan(text: "ajoutés"),
              ],
            ),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 32),
          AnimatedSize(
            duration: defaultAnimationTime,
            curve: defaultAnimationCurve,
            child: Selector<ProductsProvider, bool>(
              selector: (_, provider) => provider.lastProductsIsLoading,
              builder: (context, isLoading, _) {
                final provider = context.read<ProductsProvider>();

                return Container(
                  padding:
                      actualWidth > maxWidth
                          ? const EdgeInsets.all(32)
                          : const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child:
                      provider.lastProductsIsLoading
                          ? const Loader()
                          : SizedBox(
                            height:
                                provider.lastProducts.isNotEmpty ||
                                        provider.lastProductsIsLoading
                                    ? null
                                    : 0,
                            width: double.infinity,
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              spacing:
                                  actualWidth > maxWidth
                                      ? actualWidth /
                                          100 *
                                          2
                                      : actualWidth /
                                          100 *
                                          4,
                              children:
                                  provider.lastProducts.map((product) {
                                    return ProductCard(
                                      product: product,
                                      widthAjustment: 32,
                                    );
                                  }).toList(),
                            ),
                          ),
                );
              },
            ),
          ),
          Center(
            heightFactor: 1.5,
            child: Image.asset(
              appIcon,
              height: 160,
              cacheHeight: getCacheHeight(context, 160),
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
