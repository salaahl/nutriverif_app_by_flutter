import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_nutriverif/providers/products_provider.dart';
import '../screens/products_page.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/product_card.dart';
import '../models/model_products.dart';

class NutritionalTable extends StatefulWidget {
  final Object nutriments;

  const NutritionalTable({super.key, required this.nutriments});

  @override
  NutritionalTableState createState() => NutritionalTableState();
}

class NutritionalTableState extends State<NutritionalTable> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductsProvider>(context);

    // Convertir l'objet en une liste de paires (nom, valeur)
    final entries = (widget.nutriments as Map<String, String>).entries.toList();

    final double rowHeight = 62;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FilterChip(
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
            const SizedBox(width: 16),
            FilterChip(
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
          ],
        ),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12), // sm:rounded-lg
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
                0: FixedColumnWidth(
                  (MediaQuery.of(context).size.width / 2) - 32,
                ), // Largeur de la première colonne
                1: FixedColumnWidth(
                  (MediaQuery.of(context).size.width / 3) - 32,
                ), // Largeur de la deuxième colonne
                2: FixedColumnWidth(
                  (MediaQuery.of(context).size.width / 3) - 32,
                ), // Largeur de la troisième colonne
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
                          'Par portion'.toUpperCase(),
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
                  TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                      ),
                    ),
                    children: [
                      Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            entry.key, // Nom du nutriment (ex: 'Carbohydrates')
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
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            '-', // Par portion - Remplir selon les données disponibles
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(color: Colors.grey[100]),
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            '-', // Ajr* - Remplir si les données sont disponibles
                            style: TextStyle(fontSize: 12, color: Colors.grey),
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

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductsProvider>(context);

    // Widget principal
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(172),
        child: customAppBar(),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // Section Produit Principal
          if (provider.productIsLoading)
            loadingWidget()
          else ...[
            productDetails(context, provider.product),
            const SizedBox(height: 32),
          ],

          // Section Alternatives
          alternativeProducts(
            context,
            provider,
            loadingWidget(),
            provider.suggestedProducts,
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Widget de chargement centralisé
  Widget loadingWidget() => const Center(
    child: Padding(
      padding: EdgeInsets.all(64),
      child: CircularProgressIndicator(),
    ),
  );

  // Affichage des détails du produit
  Widget productDetails(BuildContext context, Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image du produit
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(product.image, width: 160),
        ),
        const SizedBox(height: 32),
        productInfo(context, product),
        const SizedBox(height: 32),
      ],
    );
  }

  // Affichage des informations du produit
  Widget productInfo(BuildContext context, Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nom et marque
        Text.rich(
          TextSpan(
            text: "${product.brand} - ",
            style: const TextStyle(fontSize: 20, color: Color(0xFF00BD7E)),
            children: [
              TextSpan(
                text: product.genericName,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text("Dernière mise à jour : ${product.lastUpdate}"),
        const SizedBox(height: 8),
        productImages(),
        const SizedBox(height: 8),
        productLabel(product.nutrientLevels),
        const SizedBox(height: 32),
        productDetailsBottom(context, product),
      ],
    );
  }

  // Affichage des logos
  Widget productImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        productImage("assets/images/logo.png", 100),
        productImage("assets/images/logo.png", 40),
      ],
    );
  }

  // Affichage d'une image avec une contrainte de largeur
  Widget productImage(String imageUrl, double width) {
    return Container(
      width: width,
      constraints: BoxConstraints(maxWidth: width),
      child: Image.asset(imageUrl, fit: BoxFit.cover),
    );
  }

  // Affichage des niveaux de nutriments
  Widget productLabel(Map<String, dynamic> nutrientLevels) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          nutrientLevels.entries.map((entry) {
            Color bgColor;

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
                entry.key,
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
        Text("Quantité :", style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(product.quantity),
        const SizedBox(height: 16),
        NutritionalTable(nutriments: product.nutriments),
        SizedBox(height: 32),
        Text(
          "Ingrédients :",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(product.ingredients),
        const SizedBox(height: 16),
        Text(
          "Code-barres :",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(product.id),
        const SizedBox(height: 16),
        Text(
          "Plus d'informations : ",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(product.link),
        const SizedBox(height: 16),
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
                        provider.updateInput(category);
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
    Widget loadingWidget,
    List<Products> suggestedProducts,
  ) {
    if (provider.suggestedProductsIsLoading) {
      return loadingWidget;
    } else {
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
                  suggestedProducts.map((product) {
                    return ProductCard(
                      widthAjustment: 32,
                      imageUrl: product.image,
                      title: product.brand,
                      description: product.name,
                      nutriscore: "assets/images/logo.png",
                      nova: "assets/images/logo.png",
                    );
                  }).toList(),
            ),
          ],
        ),
      );
    }
  }
}
