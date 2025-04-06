import 'package:flutter/material.dart';
import 'package:app_nutriverif/screens/main_scaffold.dart';
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
      ),
      routes: {
        '/': (context) => const MainScaffold(),
        '/product': (context) => ProductPage(),
      },
      initialRoute: '/',
    );
  }
}
