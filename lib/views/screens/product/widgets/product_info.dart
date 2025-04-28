import 'package:flutter/material.dart';

import '../../../../models/model_products.dart';

import 'package:app_nutriverif/views/screens/product/widgets/product_scores.dart';
import 'package:app_nutriverif/views/screens/product/widgets/product_nutrients.dart';
import 'package:app_nutriverif/views/screens/product/widgets/product_more_details.dart';

// Affichage des informations du produit
Widget productInfo(BuildContext context, Product product) {
  String formattedDate = '';

  if (product.lastUpdate.isNotEmpty) {
    final date = DateTime.fromMillisecondsSinceEpoch(
      int.parse(product.lastUpdate) * 1000,
    );
    formattedDate =
        'Dernière mise à jour : ${date.day}-${date.month}-${date.year}';
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Nom et marque
      Text.rich(
        TextSpan(
          text: "${product.brand} - ",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color(0xFF00BD7E),
          ),
          children: [
            TextSpan(
              text: product.name,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 8),
      Text(formattedDate),
      productScores(product.nutriscore, product.nova),
      productNutrients(product.nutrientLevels),
      productMoreDetails(context, product),
    ],
  );
}
