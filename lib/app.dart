import 'package:flutter/material.dart';
import 'package:app_nutriverif/screens/home_page.dart';
import 'package:app_nutriverif/screens/about_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriVerif',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(toolbarHeight: 172),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      routes: {
        '/': (context) => HomePage(),
        '/about': (context) => AboutPage(),
      },
      initialRoute: '/',
    );
  }
}
