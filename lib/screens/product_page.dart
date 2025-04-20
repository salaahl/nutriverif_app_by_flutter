import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:app_nutriverif/providers/products_provider.dart';
import '../screens/products_page.dart';
import '../widgets/app_bar.dart';
import '../widgets/loader.dart';
import '../widgets/product_card.dart';
import '../models/model_products.dart';

class ProductPage extends StatefulWidget {
  final Product product;

  const ProductPage({super.key, required this.product});

  @override
  State<ProductPage> createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage> {
  final Set<String> _isAnimated = {};

  @override
  void initState() {
    super.initState();

    final ProductsProvider provider = Provider.of<ProductsProvider>(
      context,
      listen: false,
    );
    final Product product = widget.product;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.setSuggestedProducts([]);

      if (product.nutriscore != 'a' || int.tryParse(product.nova) != 1) {
        provider
            .fetchSuggestedProducts(
              id: product.id,
              categories: product.categories,
              nutriscore: product.nutriscore,
              nova: product.nova,
            )
            .then((products) {
              if (mounted) {
                setState(() {
                  provider.setSuggestedProducts(products);
                });
              }
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductsProvider>(context);
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
          const SizedBox(height: 32),
          VisibilityDetector(
            key: const Key('alternatives'),
            onVisibilityChanged: (info) {
              if (info.visibleBounds.height > 0 &&
                  !_isAnimated.contains('alternatives')) {
                setState(() {
                  _isAnimated.add('alternatives');
                });
              }
            },
            child:
                _isAnimated.contains('alternatives')
                    ? TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 250),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 80 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: alternativeProducts(
                        context,
                        provider,
                        provider.suggestedProducts,
                      ),
                    )
                    : SizedBox.shrink(),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Affichage des détails du produit
  Widget productDetails(BuildContext context, Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image du produit
        AspectRatio(
          aspectRatio: 1,
          child: Hero(
            key: Key(product.id),
            tag: product.id,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  product.image.isEmpty
                      ? const Loader()
                      : Image.network(
                        product.image,
                        width: 160,
                        semanticLabel: 'Image du produit',
                      ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        productInfo(context, product),
        const SizedBox(height: 32),
      ],
    );
  }

  // Affichage des informations du produit
  Widget productInfo(BuildContext context, Product product) {
    String formattedDate = '';

    if (product.lastUpdate.isNotEmpty) {
      final date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(product.lastUpdate) * 1000,
      );
      formattedDate =
          'Dernière mise à jour : ${date.day}-${date.month}-${date.year}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nom et marque
        Text.rich(
          TextSpan(
            text: "${product.brand} - ",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF00BD7E),
            ),
            children: [
              TextSpan(
                text: product.name,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(formattedDate),
        const SizedBox(height: 16),
        productImages(product.nutriscore, product.nova),
        const SizedBox(height: 32),
        productLabel(product.nutrientLevels),
        const SizedBox(height: 32),
        productDetailsBottom(context, product),
      ],
    );
  }

  // Affichage des logos
  Widget productImages(String nutriscore, String nova) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        productImage(
          "https://static.openfoodfacts.org/images/attributes/dist/nutriscore-$nutriscore-new-fr.svg",
          100,
          nutriscore,
        ),
        const SizedBox(height: 8),
        productImage(
          "https://static.openfoodfacts.org/images/attributes/dist/nova-group-$nova.svg",
          30,
          nova,
        ),
      ],
    );
  }

  // Affichage d'une image avec une contrainte de largeur
  Widget productImage(String image, double width, String score) {
    return Container(
      constraints: BoxConstraints(maxWidth: width),
      child:
          image.isEmpty
              ? Image.asset(
                'assets/images/logo.png',
                width: width,
                fit: BoxFit.cover,
                semanticLabel: 'Nutriscore $score',
              )
              : SvgPicture.network(image, width: width, fit: BoxFit.cover),
    );
  }

  // Affichage des niveaux de nutriments
  Widget productLabel(Map<String, dynamic> nutrientLevels) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          nutrientLevels.entries.map((entry) {
            String label;
            Color bgColor;

            switch (entry.key) {
              case 'fat':
                label = 'matières grasses';
                break;
              case 'salt':
                label = 'sel';
                break;
              case 'sugars':
                label = 'sucres';
                break;
              case 'saturated-fat':
                label = 'graisses saturées';
                break;
              default:
                label = entry.key;
            }

            switch (entry.value) {
              case 'high':
                bgColor = Colors.red;
                break;
              case 'moderate':
                bgColor = Colors.orange;
                break;
              case 'low':
                bgColor = Colors.green;
                break;
              default:
                bgColor = Colors.grey;
            }

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
    );
  }

  // Détails supplémentaires du produit
  Widget productDetailsBottom(BuildContext context, Product product) {
    final provider = Provider.of<ProductsProvider>(context);
    // Categories "nettoyées"
    final categories = product.categories
        .where((e) => e.contains(':'))
        .map((e) => e.split(':')[1].replaceAll('-', ' '))
        .toList()
        .sublist(0, min(5, product.categories.length));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (product.quantity.isNotEmpty) ...[
          Text(
            "Quantité :",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(product.quantity),
          const SizedBox(height: 16),
        ],
        if (product.nutriments.keys.any(
          (key) => provider.ajrValues.containsKey(key),
        )) ...[
          NutritionalTable(product: product),
          SizedBox(height: 32),
        ],
        if (product.ingredients.isNotEmpty) ...[
          Text(
            "Ingrédients :",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(product.ingredients),
          const SizedBox(height: 24),
        ],
        if (product.id.isNotEmpty) ...[
          const Text(
            "Code-barres :",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(product.id),
          const SizedBox(height: 24),
        ],
        if (product.link.isNotEmpty) ...[
          const Text(
            "Plus d'informations : ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          InkWell(
            child: Text(
              product.link,
              style: const TextStyle(color: Colors.blue),
            ),
            onTap: () {
              launchUrlString(product.link);
            },
          ),
          const SizedBox(height: 24),
        ],
        Wrap(
          spacing: 8,
          children:
              categories
                  .map(
                    (category) => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.grey[400],
                      ),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductSearchPage(),
                          ),
                        );

                        provider.setProducts(
                          await provider.searchProductsByQuery(
                            query: category,
                            method: 'complete',
                          ),
                        );
                      },
                      child: Text(
                        "#$category",
                        style: const TextStyle(
                          inherit: true,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  // Section des produits alternatifs
  Widget alternativeProducts(
    BuildContext context,
    ProductsProvider provider,
    List<Product> suggestedProducts, {
    double widthAdjustment = 32,
  }) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      child: Container(
        height:
            provider.suggestedProductsIsLoading || suggestedProducts.isNotEmpty
                ? null
                : 0,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            const BoxShadow(
              color: Color.fromRGBO(255, 255, 255, 0.01),
              offset: Offset(0, 1),
              blurRadius: 1,
              spreadRadius: 0,
            ),
            const BoxShadow(
              color: Color.fromRGBO(50, 50, 93, 0.025),
              offset: Offset(0, 50),
              blurRadius: 100,
              spreadRadius: -20,
            ),
            const BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.03),
              offset: Offset(0, 30),
              blurRadius: 60,
              spreadRadius: -30,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text.rich(
                TextSpan(
                  text: "A",
                  style: TextStyle(
                    fontFamily: 'Grand Hotel',
                    fontSize: 32,
                    color: Colors.redAccent,
                  ),
                  children: [
                    TextSpan(
                      text: "lternatives",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            provider.suggestedProductsIsLoading
                ? const Loader()
                : Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: MediaQuery.of(context).size.width / 100 * 4,
                  children:
                      suggestedProducts.map((product) {
                        return ProductCard(
                          product: product,
                          widthAjustment: widthAdjustment,
                        );
                      }).toList(),
                ),
          ],
        ),
      ),
    );
  }
}

class NutritionalTable extends StatefulWidget {
  final Product product;

  const NutritionalTable({super.key, required this.product});

  @override
  NutritionalTableState createState() => NutritionalTableState();
}

class NutritionalTableState extends State<NutritionalTable> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductsProvider>(context);

    // Convertir l'objet en une liste de paires (nom, valeur)
    final entries = widget.product.nutriments.entries.toList();

    final double rowHeight = 85;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Material(
              child: FilterChip(
                label: const Text('Femme'),
                selected: provider.ajrSelected == 'women',
                onSelected: (selected) {
                  provider.setAjrSelected('women');
                },
                backgroundColor: Colors.grey,
                selectedColor: Color.fromRGBO(0, 189, 126, 1),
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                showCheckmark: false,
              ),
            ),
            const SizedBox(width: 16),
            Material(
              child: FilterChip(
                label: const Text('Homme'),
                selected: provider.ajrSelected == 'men',
                onSelected: (selected) {
                  provider.setAjrSelected('men');
                },
                backgroundColor: Colors.grey,
                selectedColor: const Color.fromRGBO(0, 189, 126, 1),
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                showCheckmark: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              const BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.08),
                spreadRadius: 0,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: const FractionColumnWidth(0.50),
                1: const FractionColumnWidth(0.30),
                2: const FractionColumnWidth(0.20),
              },
              children: [
                TableRow(
                  children: [
                    Container(
                      height: rowHeight,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'VALEURS NUTRITIONELLES',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: rowHeight,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          widget.product.servingSize.isNotEmpty
                              ? 'Par portion (${widget.product.servingSize})'
                                  .toUpperCase()
                              : 'Par portion (N/A)',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: rowHeight,
                      decoration: BoxDecoration(color: Colors.grey[100]),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'AJR*',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                for (var entry in entries)
                  // Je n'affiche que les nutriments élligibles aux ajr
                  if (provider.ajrValues.containsKey(entry.key))
                    TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                      ),
                      children: [
                        Container(
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              provider.ajrValues[entry.key]?['name'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[900],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              entry.value.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(color: Colors.grey[100]),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              (double.tryParse(entry.value.toString()) !=
                                          null &&
                                      provider.ajrValues[entry.key] != null)
                                  ? ('${(((double.parse(entry.value.toString())) / provider.ajrValues[entry.key]?['value']!) * 100).toStringAsFixed(0)}%')
                                  : '—',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Ajr* : Apports Journaliers Recommandés',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
