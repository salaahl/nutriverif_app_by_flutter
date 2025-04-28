import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductScores extends StatelessWidget {
  final String nutriscore;
  final String nova;

  const ProductScores({super.key, required this.nutriscore, required this.nova});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProductScore(
            imageUrl: "https://static.openfoodfacts.org/images/attributes/dist/nutriscore-$nutriscore-new-fr.svg",
            width: 100,
            score: nutriscore,
          ),
          const SizedBox(height: 8),
          _ProductScore(
            imageUrl: "https://static.openfoodfacts.org/images/attributes/dist/nova-group-$nova.svg",
            width: 30,
            score: nova,
          ),
        ],
      ),
    );
  }
}

class _ProductScore extends StatelessWidget {
  final String imageUrl;
  final double width;
  final String score;

  const _ProductScore({required this.imageUrl, required this.width, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: width),
      child: imageUrl.isEmpty
          ? Image.asset('assets/images/logo.png', width: width, fit: BoxFit.cover, semanticLabel: 'Nutriscore $score')
          : SvgPicture.network(imageUrl, width: width, fit: BoxFit.cover),
    );
  }
}
