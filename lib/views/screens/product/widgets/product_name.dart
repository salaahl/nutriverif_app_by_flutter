import 'package:flutter/material.dart';

class ProductInfo extends StatelessWidget {
  final Date lastUpdate;
  final String brand;
  final String name;

  const ProductInfo({super.key, required this.lastUpdate, required this.brand, required this.name});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.fromMillisecondsSinceEpoch(
      int.parse(lastUpdate) * 1000,
    );
    String formattedDate = 'Dernière mise à jour : ${date.day}-${date.month}-${date.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }
}
