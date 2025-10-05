import 'package:flutter/material.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

import 'package:app_nutriverif/models/model_products.dart';

import 'package:app_nutriverif/views/screens/product/product_page.dart';

import './widgets/product_card_image.dart';
import './widgets/product_card_name.dart';
import './widgets/product_card_scores.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final double widthAjustment;
  final bool animate;

  const ProductCard({
    super.key,
    required this.product,
    required this.widthAjustment,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    return animate
        ? Hero(
          key: Key(product.id),
          tag: product.id,
          child: _card(context, product, widthAjustment),
        )
        : _card(context, product, widthAjustment);
  }
}

Widget _card(context, product, widthAjustment) {
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
            productTransition(context, product);
          } else {
            // On est déjà sur la page product, pas de transition
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ProductPage(
                      id: product.id,
                      image: product.image,
                      lastUpdate: product.lastUpdate,
                      brand: product.brand,
                      name: product.name,
                      nutriscore: product.nutriscore,
                      nova: product.nova,
                      categories: product.categories,
                    ),
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
