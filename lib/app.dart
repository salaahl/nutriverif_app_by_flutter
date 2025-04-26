import 'package:flutter/material.dart';

import 'routes/app_router.dart';

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
      onGenerateRoute: generateRoute,
      initialRoute: '/',
    );
  }
}
