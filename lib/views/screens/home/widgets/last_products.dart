import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

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
                  text: " récemment ",
                  style: TextStyle(color: Colors.redAccent),
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
                final lastProducts = provider.lastProducts;

                if (lastProducts.length > 3 && actualWidth > maxWidth)
                  lastProducts.removeRange(3, 4);

                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Container(
                      padding:
                          actualWidth > maxWidth
                              ? const EdgeInsets.all(32)
                              : const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 1,
                          colors: [
                            Color.fromRGBO(255, 255, 255, 0.75),
                            Color.fromRGBO(255, 255, 255, 0.15),
                          ],
                        ), // ...
                      ),
                      child:
                          !context.read<ProductsProvider>().showLastProducts
                              ? Container(
                                margin: const EdgeInsets.only(top: 16),
                                width: double.infinity,
                                child: Tooltip(
                                  message: 'Plus de produits',
                                  child: Wrap(
                                    alignment: WrapAlignment.spaceBetween,
                                    spacing:
                                        actualWidth > maxWidth
                                            ? maxWidth / 100 * 4
                                            : actualWidth / 100 * 4,
                                    children: [
                                      ...List.generate(
                                        actualWidth > maxWidth ? 3 : 4,
                                        (_) => const ProductCard(
                                          product: null,
                                          widthAjustment: 32,
                                        ),
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            context
                                                .read<ProductsProvider>()
                                                .loadLastProducts();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            backgroundColor:
                                                const Color.fromRGBO(
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
                                ),
                              )
                              : provider.lastProductsIsLoading
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
                                          ? actualWidth / 100 * 2
                                          : actualWidth / 100 * 4,
                                  children:
                                      lastProducts.map((product) {
                                        return ProductCard(
                                          product: product,
                                          widthAjustment: 32,
                                        );
                                      }).toList(),
                                ),
                              ),
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
              color: const Color.fromRGBO(0, 0, 0, 0.75),
            ),
          ),
        ],
      ),
    );
  }
}
