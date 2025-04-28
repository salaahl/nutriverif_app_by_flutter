import 'package:flutter/material.dart';

class ProductMoreDetails extends StatelessWidget {
  final Product product;

  const ProductMoreDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final _provider = context.read<ProductsProvider>();
    final categories = product.categories
        .where((e) => e.contains(':'))
        .map((e) => e.split(':')[1].replaceAll('-', ' '))
        .toList()
        .sublist(0, min(5, product.categories.length));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (product.quantity.isNotEmpty) ...[
          Text("Quantité :", style: TextStyle(fontWeight: FontWeight.bold, height: 1.5)),
          Text(product.quantity),
          const SizedBox(height: 16),
        ],
        if (product.nutriments.keys.any((key) => _provider.ajrValues.containsKey(key))) ...[
          NutritionalTable(product: product),
          const SizedBox(height: 32),
        ],
        if (product.ingredients.isNotEmpty) ...[
          Text("Ingrédients :", style: TextStyle(fontWeight: FontWeight.bold, height: 1.5)),
          Text(product.ingredients),
          const SizedBox(height: 24),
        ],
        if (product.id.isNotEmpty) ...[
          const Text("Code-barres :", style: TextStyle(fontWeight: FontWeight.bold, height: 1.5)),
          Text(product.id),
          const SizedBox(height: 24),
        ],
        if (product.link.isNotEmpty) ...[
          const Text("Plus d'informations :", style: TextStyle(fontWeight: FontWeight.bold, height: 1.5)),
          InkWell(
            child: Text(
              product.link,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                decorationThickness: 4,
                decorationColor: Colors.redAccent,
              ),
            ),
            onTap: () => launchUrlString(product.link),
          ),
          const SizedBox(height: 24),
        ],
        Wrap(
          spacing: 8,
          children: categories.map((category) => ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.grey[400],
            ),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductSearchPage()),
              );
              await _provider.searchProducts(query: category, method: 'complete');
            },
            child: Text("#$category", style: const TextStyle(fontWeight: FontWeight.bold)),
          )).toList(),
        ),
      ],
    );
  }
}
