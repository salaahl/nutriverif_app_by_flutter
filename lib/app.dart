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
      routes: {'/': (context) => const MainScaffold()},
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '');

        if (uri.pathSegments.length == 2 &&
            uri.pathSegments.first == 'product') {
          final id = uri.pathSegments[1];
          return MaterialPageRoute(builder: (context) => ProductPage(id: id));
        }

        // fallback si la route n'existe pas
        return MaterialPageRoute(
          builder:
              (context) =>
                  Scaffold(body: Center(child: Text('Page not found'))),
        );
      },
      initialRoute: '/',
    );
  }
}
