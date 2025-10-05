import 'package:flutter/material.dart';

import 'package:app_nutriverif/models/model_products.dart';

import 'package:app_nutriverif/views/screens/product/product_page.dart';

// Styles
const screenPadding = EdgeInsets.symmetric(horizontal: 16);
const customGreen = Color.fromRGBO(0, 189, 126, 1);

// Animations
const defaultAnimationTime = Duration(milliseconds: 350);
const defaultAnimationCurve = Curves.easeInOut;

// Custom route animation
Future<dynamic> productTransition(BuildContext context, Product product) {
  return Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder:
          (context, animation, secondaryAnimation) => ProductPage(
            id: product.id,
            image: product.image,
            lastUpdate: product.lastUpdate,
            brand: product.brand,
            name: product.name,
            nutriscore: product.nutriscore,
            nova: product.nova,
            categories: product.categories,
          ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
              reverseCurve: const Interval(0.5, 1.0, curve: Curves.easeOut),
            ),
          ),
          child: child,
        );
      },
      settings: const RouteSettings(name: '/product'),
    ),
  );
}

// Others
const appIcon = 'assets/images/logo.png';
