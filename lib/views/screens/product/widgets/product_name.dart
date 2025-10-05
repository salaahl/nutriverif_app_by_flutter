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

  static const List<String> months = [
    'janvier',
    'février',
    'mars',
    'avril',
    'mai',
    'juin',
    'juillet',
    'août',
    'septembre',
    'octobre',
    'novembre',
    'décembre',
  ];

  @override
  Widget build(BuildContext context) {
    String formattedDate = '';
    if (lastUpdate.isNotEmpty) {
      final date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(lastUpdate) * 1000,
      );
      formattedDate =
          'Dernière mise à jour : ${date.day} ${months[date.month - 1]} ${date.year}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          brand,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w900,
            color: customGreen,
          ),
        ),
        Text(
          name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(formattedDate, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
