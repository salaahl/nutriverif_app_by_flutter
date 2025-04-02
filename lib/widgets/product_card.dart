import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final double
  widthAjustment; // ajustement de la largeur selon le padding des parents
  final String imageUrl;
  final String title;
  final String description;
  final String nutriscore;
  final String nova;

  const ProductCard({
    super.key,
    required this.widthAjustment,
    required this.imageUrl,
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(imageUrl, height: 80, fit: BoxFit.contain),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(
            description,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(nutriscore, height: 30),
              Image.asset(nova, height: 30),
            ],
          ),
        ],
      ),
    );
  }
}
