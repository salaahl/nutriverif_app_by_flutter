import 'package:flutter/material.dart';

import '../models/model_products.dart';

import 'package:app_nutriverif/views/screens/main_scaffold.dart';
import 'package:app_nutriverif/views/screens/products_page.dart';
import 'package:app_nutriverif/views/screens/about_page.dart';
import 'package:app_nutriverif/views/screens/product_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  Widget page;

  switch (settings.name) {
    case '/':
      page = const MainScaffold();
      break;
    case '/about':
      page = const AboutPage();
      break;
    case '/products':
      page = const ProductSearchPage();
      break;
    case '/product':
      final args = settings.arguments;
      if (args is Product) {
        page = ProductPage(product: args);
      } else {
        page = const MainScaffold();
      }
      break;
    default:
      page = const MainScaffold();
  }

  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = Curves.easeInOut;
      final slideInTween = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(slideInTween),
        child: child,
      );
    },
  );
}
