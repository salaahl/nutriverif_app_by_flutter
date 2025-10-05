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
          titleLarge: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          titleSmall: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: const TextStyle(fontSize: 16),
          bodyMedium: const TextStyle(
            fontSize: 14,
          ), // 14 est également la taille par défaut du système
          bodySmall: const TextStyle(fontSize: 12),
        ),
      ),
      onGenerateRoute: generateRoute,
      initialRoute: '/',
    );
  }
}
