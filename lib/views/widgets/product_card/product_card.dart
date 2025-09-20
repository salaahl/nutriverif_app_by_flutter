import 'package:flutter/material.dart';

import 'package:app_nutriverif/models/model_products.dart';

import 'package:app_nutriverif/views/screens/product/product_page.dart';

import './widgets/product_card_image.dart';
import './widgets/product_card_name.dart';
import './widgets/product_card_scores.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final double widthAjustment;

  const ProductCard({
    super.key,
    required this.product,
    required this.widthAjustment,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth / 100 * 48) - widthAjustment;

    return Container(
      height: 280,
      width: cardWidth,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          const BoxShadow(
            color: Color.fromRGBO(50, 50, 93, 0.025),
            offset: Offset(0, 50),
            blurRadius: 100,
            spreadRadius: -20,
          ),
          const BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.075),
            offset: Offset(0, 30),
            blurRadius: 60,
            spreadRadius: -30,
          ),
        ],
      ),
      child: Material(
        color: const Color.fromRGBO(249, 249, 249, 1),
        borderRadius: BorderRadius.circular(12),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            if (ModalRoute.of(context)?.settings.name != '/product') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          ProductPage(id: product.id, image: product.image),
                  settings: RouteSettings(name: '/product'),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          ProductPage(id: product.id, image: product.image),
                  settings: RouteSettings(name: '/product'),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ProductCardImage(
                  id: product.id,
                  image: product.image,
                  widthAjustment: widthAjustment,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 158, // 60% du container
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ProductCardName(brand: product.brand, name: product.name),
                      const SizedBox(height: 4),
                      ProductCardDetails(
                        nutriscore: product.nutriscore,
                        nova: product.nova,
                        category: product.category,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
