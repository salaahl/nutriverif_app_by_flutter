import 'package:flutter/material.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

class ProductImage extends StatelessWidget {
  final String id;
  final String image;

  const ProductImage({super.key, required this.id, required this.image});

  @override
  Widget build(BuildContext context) {
    // Permet de retourner un cacheWidth adapté à la résolution de l'écran
    int getCacheWidth(BuildContext context, double logicalWidth) {
      final ratio = MediaQuery.of(context).devicePixelRatio;
      return (logicalWidth * ratio).round();
    }

    return AspectRatio(
      aspectRatio: 1,
      child: Hero(
        key: Key(id),
        tag: id,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 32),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(48),
          ),
          child:
              image.isEmpty
                  ? Image.asset(
                    appIcon,
                    width: 160,
                    cacheWidth: getCacheWidth(context, 160),
                    semanticLabel: 'Image du produit',
                  )
                  : Image.network(
                    image,
                    width: 160,
                    cacheWidth: getCacheWidth(context, 160),
                    semanticLabel: 'Image du produit',
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        appIcon,
                        width: 160,
                        cacheWidth: getCacheWidth(context, 160),
                        semanticLabel: 'Image de remplacement (erreur réseau)',
                      );
                    },
                  ),
        ),
      ),
    );
  }
}
