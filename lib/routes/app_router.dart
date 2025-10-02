import 'package:flutter/material.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

import '../models/model_products.dart';

import 'package:app_nutriverif/views/screens/home/home_page.dart';
import 'package:app_nutriverif/views/screens/products/products_page.dart';
import 'package:app_nutriverif/views/screens/about_page.dart';
import 'package:app_nutriverif/views/screens/legal_notice.dart';
import 'package:app_nutriverif/views/screens/product/product_page.dart';
import 'package:app_nutriverif/views/screens/barcode_scanner_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  Widget page;

  switch (settings.name) {
    case '/':
      page = const HomePage();
      break;
    case '/about':
      page = const AboutPage();
      break;
    case '/legal-notice':
      page = const LegalNoticePage();
      break;
    case '/products':
      page = const ProductSearchPage();
      break;
    case '/product':
      final args = settings.arguments;
      if (args is Product) {
        page = ProductPage(
          id: args.id,
          image: args.image,
          lastUpdate: args.lastUpdate,
          brand: args.brand,
          name: args.name,
          nutriscore: args.nutriscore,
          nova: args.nova,
        );
      } else {
        page = const HomePage();
      }
      break;
    case '/scanner':
      page = const BarcodeScannerPage();
      break;
    default:
      page = const HomePage();
  }

  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = defaultAnimationCurve;
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
