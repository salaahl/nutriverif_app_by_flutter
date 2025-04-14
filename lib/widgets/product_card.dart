import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductCard extends StatelessWidget {
  final String id;
  final double
  widthAjustment; // ajustement de la largeur selon le padding des parents
  final String image;
  final String title;
  final String description;
  final String nutriscore;
  final String nova;

  const ProductCard({
    super.key,
    required this.id,
    required this.widthAjustment,
    required this.image,
    required this.title,
    required this.description,
    required this.nutriscore,
    required this.nova,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: (MediaQuery.of(context).size.width / 100 * 48) - widthAjustment,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(50, 50, 93, 0.025),
            offset: Offset(0, 50),
            blurRadius: 100,
            spreadRadius: -20,
          ),
          BoxShadow(
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
          onTap: () async {
            final result = await Navigator.pushNamed(
              context,
              "/product",
              arguments: id,
            );

            if (context.mounted && result != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    result.toString(),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 100, maxWidth: 100),
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
                        image.isEmpty
                            ? Image.asset(
                              'assets/images/logo.png',
                              height: 80,
                              fit: BoxFit.contain,
                              semanticLabel: 'Image du produit',
                            )
                            : Image.network(
                              image,
                              height: 80,
                              fit: BoxFit.contain,
                              semanticLabel: 'Image du produit',
                            ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.network(
                      "https://static.openfoodfacts.org/images/attributes/dist/nutriscore-$nutriscore-new-fr.svg",
                      height: 40,
                      semanticsLabel: 'Nutriscore $nutriscore',
                    ),
                    const SizedBox(height: 4),
                    SvgPicture.network(
                      "https://static.openfoodfacts.org/images/attributes/dist/nova-group-$nova.svg",
                      height: 40,
                      semanticsLabel: 'Nova score $nova',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
