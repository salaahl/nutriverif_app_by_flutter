import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String id;
  final String image;

  const ProductImage({super.key, required this.id, required this.image});

  @override
  Widget build(BuildContext context) {
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
            borderRadius: BorderRadius.circular(12),
          ),
          child:
              image.isEmpty
                  ? Image.asset(
                    image,
                    width: 160,
                    semanticLabel: 'Image du produit',
                  )
                  : Image.network(
                    image,
                    width: 160,
                    semanticLabel: 'Image du produit',
                  ),
        ),
      ),
    );
  }
}
