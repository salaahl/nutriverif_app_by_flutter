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
        color: const Color.fromRGBO(249, 249, 249, 1),
        borderRadius: BorderRadius.circular(12),
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
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/product',
            arguments: {':productId': ''},
          );
        },
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
                child: Image.asset(imageUrl, height: 80, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              description,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Column(
              children: [
                Image.asset(nutriscore, height: 30),
                const SizedBox(height: 4),
                Image.asset(nova, height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
