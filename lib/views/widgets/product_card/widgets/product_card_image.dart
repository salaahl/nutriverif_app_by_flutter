import 'package:flutter/material.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

class ProductCardImage extends StatelessWidget {
  final String id;
  final String image;
  final double widthAjustment;

  const ProductCardImage({
    super.key,
    required this.id,
    required this.image,
    required this.widthAjustment,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth / 100 * 48) - widthAjustment;

    // Permet de retourner un cacheWidth adapté à la résolution de l'écran
    int getCacheHeight(BuildContext context, double logicalHeight) {
      final ratio = MediaQuery.of(context).devicePixelRatio;
      return (logicalHeight * ratio).round();
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(maxHeight: 80, maxWidth: 80),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        height: cardWidth * 2,
        width: cardWidth * 2,
        child:
            image.isEmpty
                ? Image.asset(
                  appIcon,
                  height: 80,
                  cacheHeight: getCacheHeight(context, 80),
                  fit: BoxFit.contain,
                  semanticLabel: 'Image de remplacement',
                )
                : Image.network(
                  image,
                  height: 80,
                  cacheHeight: getCacheHeight(context, 80),
                  fit: BoxFit.contain,
                  semanticLabel: 'Image du produit',
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      appIcon,
                      height: 80,
                      cacheHeight: getCacheHeight(context, 80),
                      fit: BoxFit.contain,
                      semanticLabel: 'Image de remplacement (erreur réseau)',
                    );
                  },
                ),
      ),
    );
  }
}
