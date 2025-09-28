import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

import 'package:app_nutriverif/providers/products_provider.dart';

import 'package:app_nutriverif/views/widgets/loader.dart';
import 'package:app_nutriverif/views/widgets/product_card/product_card.dart';

class LastProducts extends StatelessWidget {
  const LastProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductsProvider>();

    // Permet de retourner un cacheWidth adapté à la résolution de l'écran
    int getCacheHeight(BuildContext context, double logicalHeight) {
      final ratio = MediaQuery.of(context).devicePixelRatio;
      return (logicalHeight * ratio).round();
    }

    return Column(
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
          child: Container(
            padding: const EdgeInsets.all(16),
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
                        spacing: MediaQuery.of(context).size.width / 100 * 4,
                        children:
                            provider.lastProducts.map((product) {
                              return ProductCard(
                                product: product,
                                widthAjustment: 32,
                              );
                            }).toList(),
                      ),
                    ),
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
    );
  }
}
