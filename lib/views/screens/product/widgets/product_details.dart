import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:app_nutriverif/providers/products_provider.dart';

import 'package:app_nutriverif/views/screens/products_page.dart';

import './product_nutriments.dart';

class ProductDetails extends StatelessWidget {
  final String id;
  final List<String> categories;
  final String quantity;
  final String servingSize;
  final String ingredients;
  final Map<String, dynamic> nutriments;
  final String manufacturingPlace;
  final String link;

  const ProductDetails({
    super.key,
    this.id = '',
    this.categories = const [],
    this.quantity = '',
    this.servingSize = '',
    this.ingredients = '',
    this.nutriments = const {},
    this.manufacturingPlace = '',
    this.link = '',
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductsProvider>();

    final frenchCategories =
        categories
            .where((e) => e.startsWith('fr:'))
            .map((e) => e.replaceAll('fr:', '').replaceAll('-', ' '))
            .toList();

    final categoriesFiltered = frenchCategories.sublist(
      0,
      min(5, frenchCategories.length),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (quantity.isNotEmpty) ...[
          Text(
            "Quantité :",
            style: TextStyle(fontWeight: FontWeight.bold, height: 1.5),
          ),
          Text(quantity),
          const SizedBox(height: 32),
        ],
        if (nutriments.keys.any(
          (key) => provider.ajrValues.containsKey(key),
        )) ...[
          NutritionalTable(nutriments: nutriments, servingSize: servingSize),
          const SizedBox(height: 32),
        ],
        if (ingredients.isNotEmpty) ...[
          Text(
            "Ingrédients :",
            style: TextStyle(fontWeight: FontWeight.bold, height: 1.5),
          ),
          Text(ingredients),
          const SizedBox(height: 24),
        ],
        if (id.isNotEmpty) ...[
          const Text(
            "Code-barres :",
            style: TextStyle(fontWeight: FontWeight.bold, height: 1.5),
          ),
          Text(id),
          const SizedBox(height: 24),
        ],
        if (link.isNotEmpty) ...[
          const Text(
            "Plus d'informations :",
            style: TextStyle(fontWeight: FontWeight.bold, height: 1.5),
          ),
          InkWell(
            child: Text(
              link,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                decorationThickness: 4,
                decorationColor: Colors.redAccent,
              ),
            ),
            onTap: () => launchUrlString(link),
          ),
          const SizedBox(height: 24),
        ],
        Wrap(
          spacing: 8,
          children:
              categoriesFiltered
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
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}
