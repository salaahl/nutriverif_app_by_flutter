import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_nutriverif/providers/products_provider.dart';

import 'package:app_nutriverif/views/widgets/app_bar.dart';
import 'package:app_nutriverif/views/widgets/loader.dart';

import './widgets/product_image.dart';
import './widgets/product_name.dart';
import './widgets/product_details.dart';
import './widgets/product_nutrients.dart';
import './widgets/product_scores.dart';
import './widgets/product_alternatives.dart';

class ProductPage extends StatefulWidget {
  final String id;
  final String image;

  const ProductPage({super.key, required this.id, required this.image});

  @override
  State<ProductPage> createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage> {
  late ProductsProvider _provider;

  @override
  void initState() {
    super.initState();

    _provider = context.read<ProductsProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.loadProductById(widget.id);
      _provider.setSuggestedProducts([]);

      if (_provider.product.nutriscore != 'a' ||
          int.tryParse(_provider.product.nova) != 1) {
        _provider.loadSuggestedProducts(
          id: _provider.product.id,
          categories: _provider.product.categories,
          nutriscore: _provider.product.nutriscore,
          nova: _provider.product.nova,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _provider = context.watch<ProductsProvider>();

    if (_provider.productIsLoading) {
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
          ProductImage(id: widget.id, image: widget.image),
          ProductName(
            lastUpdate: _provider.product.lastUpdate,
            brand: _provider.product.brand,
            name: _provider.product.name,
          ),
          ProductScores(
            nutriscore: _provider.product.nutriscore,
            nova: _provider.product.nova,
          ),
          ProductNutrients(nutrients: _provider.product.nutrientLevels),
          ProductDetails(
            id: _provider.product.id,
            categories: _provider.product.categories,
            quantity: _provider.product.quantity,
            servingSize: _provider.product.servingSize,
            nutriments: _provider.product.nutriments,
            ingredients: _provider.product.ingredients,
            manufacturingPlace: _provider.product.manufacturingPlace,
            link: _provider.product.link,
          ),
          alternativeProducts(context, _provider.suggestedProducts),
        ],
      ),
    );
  }
}
