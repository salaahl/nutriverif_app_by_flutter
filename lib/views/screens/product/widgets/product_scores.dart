import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            imageUrl: "assets/images/nutriscore-$nutriscore.svg",
            width: 85,
            score: nutriscore,
          ),
          const SizedBox(height: 8),
          _ProductScore(
            imageUrl: "assets/images/nova-group-$nova.svg",
            width: 25,
            score: nova,
          ),
          if (novaDescription.containsKey(nova)) ...[
            const SizedBox(height: 2),
            Text(
              '(${novaDescription[nova] as String})',
              style: Theme.of(context).textTheme.bodySmall,
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
      child: SvgPicture.asset(
        imageUrl,
        width: width,
        fit: BoxFit.cover,
        semanticsLabel: "Score $score",
      ),
    );
  }
}
