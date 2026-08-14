import 'package:flutter/material.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

class ProductCardImagePlaceholder extends StatelessWidget {
  final double widthAjustment;

  const ProductCardImagePlaceholder({super.key, required this.widthAjustment});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth / 100 * 48) - widthAjustment;

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
        child: Image.asset(
          appIcon,
          height: 80,
          color: Colors.black.withValues(alpha: 0.75),
          cacheHeight: getCacheHeight(context, 80),
          fit: BoxFit.contain,
          semanticLabel: 'Image de remplacement',
        ),
      ),
    );
  }
}
