import 'package:flutter/material.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

class ProductName extends StatelessWidget {
  final String lastUpdate;
  final String brand;
  final String name;

  const ProductName({
    super.key,
    required this.lastUpdate,
    required this.brand,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = '';
    if (lastUpdate.isNotEmpty) {
      final date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(lastUpdate) * 1000,
      );
      formattedDate =
          'Dernière mise à jour : ${date.day}-${date.month}-${date.year}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: "$brand - ",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: customGreen,
            ),
            children: [
              TextSpan(
                text: name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
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
