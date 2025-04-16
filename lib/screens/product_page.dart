import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:app_nutriverif/providers/products_provider.dart';
import '../screens/products_page.dart';
import '../widgets/app_bar.dart';
import '../widgets/product_card.dart';
import '../models/model_products.dart';

class ProductPage extends StatefulWidget {
  final String id;

  const ProductPage({super.key, required this.id});

  @override
  State<ProductPage> createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage> {
  final Set<String> _isAnimated = {};
  Widget loadingWidget() => const Center(
    child: Padding(
      padding: EdgeInsets.all(64),
      child: CircularProgressIndicator(
        color: Color(0xFF00BD7E),
        strokeWidth: 8,
      ),
    ),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final provider = Provider.of<ProductsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductsProvider>(context);
    final String id = widget.id;
    final Product product =
        (provider.products[id] ??
                provider.suggestedProducts[id] ??
                provider.lastProducts[id])
            as Product;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          myAppBar(context),
          productDetails(context, product),
          const SizedBox(height: 32),
          VisibilityDetector(
            key: Key('alternatives'),
            onVisibilityChanged: (info) {
              if (info.visibleBounds.height > 50 &&
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
                            offset: Offset(0, 100 * (1 - value)),
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
                    : SizedBox(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                    ),
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
                      ? Image.asset(
                        'assets/images/logo.png',
                        width: 160,
                        semanticLabel: 'Image du produit',
                      )
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
    final date = DateTime.fromMillisecondsSinceEpoch(
      int.parse(product.lastUpdate) * 1000,
    );
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
        Text("Dernière mise à jour : ${date.day}-${date.month}-${date.year}"),
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
          const SizedBox(height: 16),
        ],
        if (product.id.isNotEmpty) ...[
          Text(
            "Code-barres :",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(product.id),
          const SizedBox(height: 16),
        ],
        if (product.link.isNotEmpty) ...[
          Text(
            "Plus d'informations : ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(product.link),
          const SizedBox(height: 16),
        ],
        Wrap(
          spacing: 8,
          children:
              product.categories
                  .map(
                    (category) => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.grey[400],
                      ),
                      onPressed: () {
                        provider.searchProductsByQuery(
                          userInput: category,
                          method: 'complete',
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductSearchPage(),
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
    Map<String, Product> suggestedProducts,
  ) {
    if (provider.suggestedProductsIsLoading) {
      return loadingWidget();
    } else if (provider.suggestedProducts.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(255, 255, 255, 0.01),
              offset: const Offset(0, 1),
              blurRadius: 1,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: const Color.fromRGBO(50, 50, 93, 0.025),
              offset: const Offset(0, 50),
              blurRadius: 100,
              spreadRadius: -20,
            ),
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.03),
              offset: const Offset(0, 30),
              blurRadius: 60,
              spreadRadius: -30,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text.rich(
                TextSpan(
                  text: "A",
                  style: const TextStyle(
                    fontFamily: 'Grand Hotel',
                    fontSize: 32,
                    color: Colors.redAccent,
                  ),
                  children: [
                    TextSpan(
                      text: "lternatives",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: MediaQuery.of(context).size.width / 100 * 4,
              children:
                  suggestedProducts.entries.map((entry) {
                    return ProductCard(
                      id: entry.key,
                      widthAjustment: 32,
                      image: entry.value.image,
                      title: entry.value.brand,
                      description: entry.value.name,
                      nutriscore: entry.value.nutriscore,
                      nova: entry.value.nova,
                    );
                  }).toList(),
            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
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
                label: Text('Femme'),
                selected: provider.ajrSelected == 'women',
                onSelected: (selected) {
                  provider.updateAjrSelected('women');
                },
                backgroundColor: Colors.grey,
                selectedColor: Color.fromRGBO(0, 189, 126, 1),
                labelStyle: TextStyle(
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
                label: Text('Homme'),
                selected: provider.ajrSelected == 'men',
                onSelected: (selected) {
                  provider.updateAjrSelected('men');
                },
                backgroundColor: Colors.grey,
                selectedColor: Color.fromRGBO(0, 189, 126, 1),
                labelStyle: TextStyle(
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
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.08),
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
                0: FractionColumnWidth(0.50),
                1: FractionColumnWidth(0.30),
                2: FractionColumnWidth(0.20),
              },
              children: [
                TableRow(
                  children: [
                    Container(
                      height: rowHeight,
                      decoration: BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'Valeurs nutritionnelles'.toUpperCase(),
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
                      decoration: BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          widget.product.servingSize.isNotEmpty
                              ? 'Par portion (${widget.product.servingSize})'
                                  .toUpperCase()
                              : 'Par portion (N/A)',
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
                      decoration: BoxDecoration(color: Colors.grey[100]),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'Ajr*'.toUpperCase(),
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
                          decoration: BoxDecoration(color: Colors.white),
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
                          decoration: BoxDecoration(color: Colors.white),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              entry.value.toStringAsFixed(0).toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(color: Colors.grey[100]),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              (double.tryParse(entry.value.toString()) !=
                                          null &&
                                      provider.ajrValues[entry.key] != null)
                                  ? ('${(((double.parse(entry.value.toString())) / provider.ajrValues[entry.key]?['value']!) * 100).toStringAsFixed(0)}%')
                                  : '—',
                              style: TextStyle(
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
        SizedBox(height: 8),
        Text(
          'Ajr* : Apports Journaliers Recommandés',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
