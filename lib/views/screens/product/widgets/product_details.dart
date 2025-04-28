import 'package:flutter/material.dart';
import '../../../widgets/loader.dart';
import '../../../../models/model_products.dart';

import 'package:app_nutriverif/views/screens/product/widgets/product_info.dart';

Widget productDetails(BuildContext context, Product product) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Image du produit
      AspectRatio(
        aspectRatio: 1,
        child: Hero(
          key: Key(product.id),
          tag: product.id,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                product.image.isEmpty
                    ? const Loader()
                    : Image.network(
                      product.image,
                      width: 160,
                      semanticLabel: 'Image du produit',
                    ),
          ),
        ),
      ),
      const SizedBox(height: 32),
      productInfo(context, product),
      const SizedBox(height: 32),
    ],
  );
}
