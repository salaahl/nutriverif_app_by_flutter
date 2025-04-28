import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_nutriverif/providers/products_provider.dart';
import '../../../widgets/product_card.dart';
import '../../../widgets/loader.dart';
import '../../../../models/model_products.dart';

Widget alternativeProducts(
  BuildContext context,
  List<Product> suggestedProducts,
) {
  final provider = context.watch<ProductsProvider>();

  return AnimatedSize(
    duration: const Duration(milliseconds: 350),
    curve: Curves.easeInOut,
    child: Container(
      height:
          provider.suggestedProductsIsLoading || suggestedProducts.isNotEmpty
              ? null
              : 0,
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
          const Center(
            child: Text.rich(
              TextSpan(
                text: "A",
                style: TextStyle(
                  fontFamily: 'Grand Hotel',
                  fontSize: 32,
                  color: Colors.redAccent,
                ),
                children: [
                  TextSpan(
                    text: "lternatives",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          provider.suggestedProductsIsLoading
              ? const Loader()
              : Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: MediaQuery.of(context).size.width / 100 * 4,
                children:
                    suggestedProducts.map((product) {
                      return ProductCard(product: product, widthAjustment: 32);
                    }).toList(),
              ),
        ],
      ),
    ),
  );
}
