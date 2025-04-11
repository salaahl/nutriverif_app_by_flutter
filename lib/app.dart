import 'package:flutter/material.dart';
import 'package:app_nutriverif/screens/main_scaffold.dart';
import 'package:app_nutriverif/screens/products_page.dart';
import 'package:app_nutriverif/screens/about_page.dart';
import 'package:app_nutriverif/screens/product_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriVerif',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          toolbarHeight: 172,
          backgroundColor: Colors.black,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
        ).copyWith(surface: const Color.fromRGBO(245, 245, 245, 1)),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onGenerateRoute: (settings) {
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
            final id = settings.arguments as String?;
            page = ProductPage(id: id);
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
              child: 
              child,
            );
          },
        );
      },
      initialRoute: '/',
    );
  }
}
