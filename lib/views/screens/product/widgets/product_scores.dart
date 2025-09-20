import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

class ProductScores extends StatelessWidget {
  final String nutriscore;
  final String nova;

  const ProductScores({
    super.key,
    required this.nutriscore,
    required this.nova,
  });

  static const novaDescription = {
    '1': 'Aliments non transformés / minimalement',
    '2': 'Ingrédients culinaires transformés',
    '3': 'Aliments transformés',
    '4': 'Produits ultra-transformés',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProductScore(
            imageUrl:
                "https://static.openfoodfacts.org/images/attributes/dist/nutriscore-$nutriscore-new-fr.svg",
            width: 85,
            score: nutriscore,
          ),
          const SizedBox(height: 8),
          _ProductScore(
            imageUrl:
                "https://static.openfoodfacts.org/images/attributes/dist/nova-group-$nova.svg",
            width: 25,
            score: nova,
          ),
          if (novaDescription.containsKey(nova)) ...[
            const SizedBox(height: 2),
            Text(
              '(${novaDescription[nova] as String})',
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProductScore extends StatelessWidget {
  final String imageUrl;
  final double width;
  final String score;

  const _ProductScore({
    required this.imageUrl,
    required this.width,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: width),
      child:
          imageUrl.isEmpty
              ? Image.asset(
                appIcon,
                width: width,
                fit: BoxFit.cover,
                semanticLabel: 'Nutriscore $score',
              )
              : SvgPicture.network(imageUrl, width: width, fit: BoxFit.cover),
    );
  }
}
