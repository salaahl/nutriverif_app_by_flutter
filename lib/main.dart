import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:app_nutriverif/app.dart';
import 'package:provider/provider.dart';
import 'package:app_nutriverif/providers/products_provider.dart';

void main() {
  // Couleurs de la barre de notification
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ),
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ProductsProvider(),
      child: const MyApp(),
    ),
  );
}
