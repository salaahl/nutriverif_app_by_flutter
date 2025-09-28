import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:app_nutriverif/providers/products_provider.dart';

import 'package:app_nutriverif/views/screens/products/products_page.dart';

import './product_nutriments.dart';

class ProductDetails extends StatefulWidget {
  final String id;
  final List<String> categories;
  final String quantity;
  final String servingSize;
  final String ingredients;
  final Map<String, dynamic> nutriments;
  final String manufacturingPlace;
  final String link;

  const ProductDetails({
    super.key,
    this.id = '',
    this.categories = const [],
    this.quantity = '',
    this.servingSize = '',
    this.ingredients = '',
    this.nutriments = const {},
    this.manufacturingPlace = '',
    this.link = '',
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late ProductsProvider _provider;

  List<String> categoriesTranslated = [];
  bool categoriesIsLoading = true;

  @override
  void initState() {
    super.initState();

    _provider = context.read<ProductsProvider>();
    _provider.getTranslatedCategories(widget.categories).then((categories) {
      if (mounted) {
        setState(() {
          categoriesTranslated = categories;
          categoriesIsLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _provider = context.watch<ProductsProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.quantity.isNotEmpty) ...[
          Text(
            "Quantité :",
            style: TextStyle(fontWeight: FontWeight.bold, height: 1.5),
          ),
          Text(widget.quantity),
          const SizedBox(height: 32),
        ],
        if (widget.nutriments.keys.any(
          (key) => _provider.ajrValues.containsKey(key),
        )) ...[
          NutritionalTable(
            nutriments: widget.nutriments,
            servingSize: widget.servingSize,
          ),
          const SizedBox(height: 32),
        ],
        if (widget.ingredients.isNotEmpty) ...[
          const Text(
            "Ingrédients :",
            style: TextStyle(fontWeight: FontWeight.bold, height: 1.5),
          ),
          Text(widget.ingredients),
          const SizedBox(height: 24),
        ],
        if (widget.id.isNotEmpty) ...[
          const Text(
            "Code-barres :",
            style: TextStyle(fontWeight: FontWeight.bold, height: 1.5),
          ),
          Text(widget.id),
          const SizedBox(height: 24),
        ],
        if (widget.link.isNotEmpty) ...[
          const Text(
            "Plus d'informations :",
            style: TextStyle(fontWeight: FontWeight.bold, height: 1.5),
          ),
          InkWell(
            child: Text(
              widget.link,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                decorationThickness: 4,
                decorationColor: Colors.redAccent,
              ),
            ),
            onTap: () => launchUrlString(widget.link),
          ),
          const SizedBox(height: 24),
        ],
        Wrap(
          spacing: 8,
          children:
              categoriesIsLoading
                  ? [const CategoriesLoader()]
                  : categoriesTranslated.isEmpty
                  ? [const SizedBox.shrink()]
                  : categoriesTranslated
                      .where(
                        (category) => category.trim().isNotEmpty,
                      ) // Empêcher les chaines de caractères vides
                      .map(
                        (category) => CategoryButton(
                          key: ValueKey(category),
                          provider: _provider,
                          category: category,
                        ),
                      )
                      .toList(),
        ),
      ],
    );
  }
}

class CategoriesLoader extends StatefulWidget {
  const CategoriesLoader({super.key});

  @override
  State<CategoriesLoader> createState() => _CategoriesLoaderState();
}

class _CategoriesLoaderState extends State<CategoriesLoader> {
  int _animationKey = 0;

  void _restartAnimation() {
    setState(() {
      _animationKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(_animationKey),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      builder: (context, value, child) {
        final dotsCount = (value * 4).floor().clamp(0, 3);
        return Text(
          "Chargement des catégories${'.' * dotsCount}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
      },
      onEnd: _restartAnimation,
    );
  }
}

class CategoryButton extends StatelessWidget {
  final ProductsProvider provider;
  final String category;

  const CategoryButton({
    super.key,
    required this.provider,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[400],
      ),
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductSearchPage()),
        );
        await provider.searchProducts(query: category, method: 'complete');
      },
      child: Text(
        "#$category",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
