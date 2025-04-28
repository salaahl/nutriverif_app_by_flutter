import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_nutriverif/providers/products_provider.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/loader.dart';
import '../../../models/model_products.dart';

import './widgets/product_details.dart';
import './widgets/product_alternatives.dart';

class ProductPage extends StatefulWidget {
  final Product product;

  const ProductPage({super.key, required this.product});

  @override
  State<ProductPage> createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage> {
  late ProductsProvider _provider;

  @override
  void initState() {
    super.initState();

    _provider = context.read<ProductsProvider>();
    final Product product = widget.product;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.setSuggestedProducts([]);

      if (product.nutriscore != 'a' || int.tryParse(product.nova) != 1) {
        _provider.loadSuggestedProducts(
          id: product.id,
          categories: product.categories,
          nutriscore: product.nutriscore,
          nova: product.nova,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _provider = context.watch<ProductsProvider>();
    final Product product = widget.product;

    if (product.id.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Loader(),
      );
    }

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          myAppBar(context),
          productDetails(context, product),
          alternativeProducts(context, _provider.suggestedProducts),
        ],
      ),
    );
  }
}
