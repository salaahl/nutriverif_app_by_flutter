import 'package:flutter/material.dart';

import 'package:app_nutriverif/models/model_products.dart';

import 'package:app_nutriverif/views/screens/product/product_page.dart';

import './widgets/product_card_image.dart';
import './widgets/product_card_name.dart';
import './widgets/product_card_scores.dart';

import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:app_nutriverif/providers/products_provider.dart';

import 'package:app_nutriverif/views/screens/products/products_page.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final double widthAjustment;
  final bool animate;

  const ProductCard({
    super.key,
    required this.product,
    required this.widthAjustment,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth / 100 * 48) - widthAjustment;

    final provider = context.read<ProductsProvider>();

    // Permet de retourner un cacheWidth adapté à la résolution de l'écran
    int getCacheHeight(BuildContext context, double logicalHeight) {
      final ratio = MediaQuery.of(context).devicePixelRatio;
      return (logicalHeight * ratio).round();
    }

    return Hero(
      key: Key(product.id),
      tag: product.id,
      child: Container(
        height: 280,
        width: cardWidth,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            const BoxShadow(
              color: Color.fromRGBO(50, 50, 93, 0.025),
              offset: Offset(0, 50),
              blurRadius: 100,
              spreadRadius: -20,
            ),
            const BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.075),
              offset: Offset(0, 30),
              blurRadius: 60,
              spreadRadius: -30,
            ),
          ],
        ),
        child: Material(
          color: const Color.fromRGBO(249, 249, 249, 1),
          borderRadius: BorderRadius.circular(12),
          elevation: 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              if (ModalRoute.of(context)?.settings.name != '/product') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            ProductPage(product: product, image: product.image),
                    settings: RouteSettings(name: '/product'),
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            ProductPage(product: product, image: product.image),
                    settings: RouteSettings(name: '/product'),
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                      maxHeight: 80,
                      maxWidth: 80,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: cardWidth * 2,
                    width: cardWidth * 2,
                    child:
                        product.image.isEmpty
                            ? Image.asset(
                              appIcon,
                              height: 80,
                              cacheHeight: getCacheHeight(context, 80),
                              fit: BoxFit.contain,
                              semanticLabel: 'Image de remplacement',
                            )
                            : Image.network(
                              product.image,
                              height: 80,
                              cacheHeight: getCacheHeight(context, 80),
                              fit: BoxFit.contain,
                              semanticLabel: 'Image du produit',
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  appIcon,
                                  height: 80,
                                  cacheHeight: getCacheHeight(context, 80),
                                  fit: BoxFit.contain,
                                  semanticLabel:
                                      'Image de remplacement (erreur réseau)',
                                );
                              },
                            ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 158, // 60% du container
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.brand,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w500,
                                color: customGreen,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SvgPicture.asset(
                              "assets/images/nutriscore-${product.nutriscore}.svg",
                              height: 40,
                              semanticsLabel:
                                  'Nutriscore ${product.nutriscore}',
                            ),
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SvgPicture.asset(
                                  "assets/images/nova-group-${product.nova}.svg",
                                  height: 35,
                                  semanticsLabel: 'Nova score ${product.nova}',
                                ),
                                product.category.isEmpty ||
                                        !product.category.startsWith('fr:')
                                    ? const SizedBox.shrink()
                                    : Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 16),
                                        child: Tooltip(
                                          message:
                                              "Voir d'autres produits de la catégorie ${product.category.split(":")[1].replaceAll('-', ' ')}",
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              foregroundColor: Colors.black,
                                              elevation: 0,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                  ),
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              minimumSize: const Size(0, 25),
                                            ),
                                            onPressed: () async {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          ProductSearchPage(),
                                                ),
                                              );
                                              await provider.searchProducts(
                                                query: product.category
                                                    .split(":")[1]
                                                    .replaceAll('-', ' '),
                                                method: 'complete',
                                              );
                                            },
                                            child: Text(
                                              "#${product.category.split(":")[1].replaceAll('-', ' ')}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                              style: TextStyle(
                                                fontSize:
                                                    Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .fontSize! -
                                                    2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
