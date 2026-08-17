import 'dart:async';
import 'package:http/http.dart' as http;
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

  // Réveil du proxy
  unawaited(
    http
        .get(Uri.parse('https://jokes-api-platform.onrender.com/'))
        .timeout(const Duration(seconds: 60))
        .catchError((error) {
          return http.Response('', 500);
        }),
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ProductsProvider(),
      child: const MyApp(),
    ),
  );
}
