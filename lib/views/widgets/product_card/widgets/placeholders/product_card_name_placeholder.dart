import 'package:flutter/material.dart';

class ProductCardNamePlaceholder extends StatelessWidget {
  const ProductCardNamePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Colors.black.withValues(alpha: 0.05),
                Colors.black.withValues(alpha: 0.1),
                Colors.black.withValues(alpha: 0.15),
              ],
              stops: const [0.3, 0.6, 1.0],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 80,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Colors.black.withValues(alpha: 0.05),
                Colors.black.withValues(alpha: 0.1),
                Colors.black.withValues(alpha: 0.15),
              ],
              stops: const [0.3, 0.6, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}
