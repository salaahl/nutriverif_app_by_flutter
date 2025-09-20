import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:app_nutriverif/providers/products_provider.dart';

import 'package:app_nutriverif/views/screens/products_page.dart';

// Contient également la catégorie du produit
class ProductCardDetails extends StatelessWidget {
  final String nutriscore;
  final String nova;
  final String category;

  const ProductCardDetails({
    super.key,
    required this.nutriscore,
    required this.nova,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductsProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SvgPicture.network(
          "https://static.openfoodfacts.org/images/attributes/dist/nutriscore-$nutriscore-new-fr.svg",
          height: 40,
          semanticsLabel: 'Nutriscore $nutriscore',
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SvgPicture.network(
              "https://static.openfoodfacts.org/images/attributes/dist/nova-group-$nova.svg",
              height: 35,
              semanticsLabel: 'Nova score $nova',
            ),
            category.isEmpty || !category.startsWith('fr:')
                ? const SizedBox.shrink()
                : Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 16),
                    child: Tooltip(
                      message:
                          "Voir d'autres produits de la catégorie ${category.split(":")[1].replaceAll('-', ' ')}",
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: const Size(0, 25),
                        ),
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductSearchPage(),
                            ),
                          );
                          await provider.searchProducts(
                            query: category.split(":")[1].replaceAll('-', ' '),
                            method: 'complete',
                          );
                        },
                        child: Text(
                          "#${category.split(":")[1].replaceAll('-', ' ')}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ],
    );
  }
}
