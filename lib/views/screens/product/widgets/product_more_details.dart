import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../products_page.dart';
import 'package:app_nutriverif/providers/products_provider.dart';
import 'package:app_nutriverif/models/model_products.dart';
import 'package:app_nutriverif/views/screens/product/widgets/product_nutriments.dart';
import 'dart:math';

// Détails supplémentaires du produit
Widget productMoreDetails(BuildContext context, Product product) {
  final provider = context.read<ProductsProvider>();

  // Categories "nettoyées"
  final categories = product.categories
      .where((e) => e.contains(':'))
      .map((e) => e.split(':')[1].replaceAll('-', ' '))
      .toList()
      .sublist(0, min(5, product.categories.length));

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (product.quantity.isNotEmpty) ...[
        Text(
          "Quantité :",
          style: TextStyle(fontWeight: FontWeight.bold, height: 1.5),
        ),
        Text(product.quantity),
        const SizedBox(height: 16),
      ],
      if (product.nutriments.keys.any(
        (key) => provider.ajrValues.containsKey(key),
      )) ...[
        NutritionalTable(product: product),
        SizedBox(height: 32),
      ],
      if (product.ingredients.isNotEmpty) ...[
        Text(
          "Ingrédients :",
          style: TextStyle(fontWeight: FontWeight.bold, height: 1.5),
        ),
        Text(product.ingredients),
        const SizedBox(height: 24),
      ],
      if (product.id.isNotEmpty) ...[
        const Text(
          "Code-barres :",
          style: TextStyle(fontWeight: FontWeight.bold, height: 1.5),
        ),
        Text(product.id),
        const SizedBox(height: 24),
      ],
      if (product.link.isNotEmpty) ...[
        const Text(
          "Plus d'informations : ",
          style: TextStyle(fontWeight: FontWeight.bold, height: 1.5),
        ),
        InkWell(
          child: Text(
            product.link,
            style: const TextStyle(
              decoration: TextDecoration.underline,
              decorationThickness: 4,
              decorationColor: Colors.redAccent,
            ),
          ),
          onTap: () {
            launchUrlString(product.link);
          },
        ),
        const SizedBox(height: 24),
      ],
      Wrap(
        spacing: 8,
        children:
            categories
                .map(
                  (category) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey[400],
                    ),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductSearchPage(),
                        ),
                      );

                      await provider.searchProducts(
                        query: category,
                        method: 'complete',
                      );
                    },
                    child: Text(
                      "#$category",
                      style: const TextStyle(
                        inherit: true,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    ],
  );
}
