import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

import '../../models/model_products.dart';

import 'package:app_nutriverif/providers/products_provider.dart';

import 'package:app_nutriverif/views/screens/product/product_page.dart';
import 'package:app_nutriverif/views/screens/products_page.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final double widthAjustment;

  const ProductCard({
    super.key,
    required this.product,
    required this.widthAjustment,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductsProvider>();

    return Container(
      key: Key(product.id),
      height: 280,
      width: (MediaQuery.of(context).size.width / 100 * 48) - widthAjustment,
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
                          ProductPage(id: product.id, image: product.image),
                  settings: RouteSettings(name: '/product'),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          ProductPage(id: product.id, image: product.image),
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
                Center(
                  child: Hero(
                    key: Key(product.id),
                    tag: product.id,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        maxHeight: 80,
                        maxWidth: 80,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height:
                          (MediaQuery.of(context).size.width / 100 * 48) -
                          widthAjustment * 2,
                      width:
                          (MediaQuery.of(context).size.width / 100 * 48) -
                          widthAjustment * 2,
                      child:
                          product.image.isEmpty
                              ? Image.asset(
                                appIcon,
                                height: 80,
                                fit: BoxFit.contain,
                                semanticLabel: 'Image du produit',
                              )
                              : Image.network(
                                product.image,
                                height: 80,
                                fit: BoxFit.contain,
                                semanticLabel: 'Image du produit',
                              ),
                    ),
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
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SvgPicture.network(
                            "https://static.openfoodfacts.org/images/attributes/dist/nutriscore-${product.nutriscore}-new-fr.svg",
                            height: 40,
                            semanticsLabel: 'Nutriscore ${product.nutriscore}',
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SvgPicture.network(
                                "https://static.openfoodfacts.org/images/attributes/dist/nova-group-${product.nova}.svg",
                                height: 35,
                                semanticsLabel: 'Nova score ${product.nova}',
                              ),
                              product.category.isEmpty ||
                                      !product.category.startsWith('fr:')
                                  ? const SizedBox.shrink()
                                  : Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 16),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black,
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
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
                                          style: const TextStyle(fontSize: 10),
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
    );
  }
}
