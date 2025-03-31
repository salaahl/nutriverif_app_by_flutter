import 'package:flutter/material.dart';
import 'package:app_nutriverif/app.dart';
import 'package:provider/provider.dart';
import 'package:app_nutriverif/providers/products_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ProductsProvider(),
      child: const MyApp(),
    ),
  );
}
