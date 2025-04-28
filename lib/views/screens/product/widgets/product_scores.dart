import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget productScores(String nutriscore, String nova) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        productScore(
          "https://static.openfoodfacts.org/images/attributes/dist/nutriscore-$nutriscore-new-fr.svg",
          100,
          nutriscore,
        ),
        const SizedBox(height: 8),
        productScore(
          "https://static.openfoodfacts.org/images/attributes/dist/nova-group-$nova.svg",
          30,
          nova,
        ),
      ],
    ),
  );
}

Widget productScore(String image, double width, String score) {
  return Container(
    constraints: BoxConstraints(maxWidth: width),
    child:
        image.isEmpty
            ? Image.asset(
              'assets/images/logo.png',
              width: width,
              fit: BoxFit.cover,
              semanticLabel: 'Nutriscore $score',
            )
            : SvgPicture.network(image, width: width, fit: BoxFit.cover),
  );
}
