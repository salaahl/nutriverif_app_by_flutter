import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_nutriverif/providers/products_provider.dart';
import '../../../../models/model_products.dart';

class NutritionalTable extends StatefulWidget {
  final Product product;

  const NutritionalTable({super.key, required this.product});

  @override
  NutritionalTableState createState() => NutritionalTableState();
}

class NutritionalTableState extends State<NutritionalTable> {
  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductsProvider>();

    // Convertir l'objet en une liste de paires (nom, valeur)
    final entries = widget.product.nutriments.entries.toList();

    final double rowHeight = 85;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Material(
              child: FilterChip(
                label: const Text('Femme'),
                selected: provider.ajrSelected == 'women',
                onSelected: (selected) {
                  provider.setAjrSelected('women');
                },
                backgroundColor: Colors.grey,
                selectedColor: Color.fromRGBO(0, 189, 126, 1),
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                showCheckmark: false,
              ),
            ),
            const SizedBox(width: 16),
            Material(
              child: FilterChip(
                label: const Text('Homme'),
                selected: provider.ajrSelected == 'men',
                onSelected: (selected) {
                  provider.setAjrSelected('men');
                },
                backgroundColor: Colors.grey,
                selectedColor: const Color.fromRGBO(0, 189, 126, 1),
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                showCheckmark: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              const BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.08),
                spreadRadius: 0,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: const FractionColumnWidth(0.50),
                1: const FractionColumnWidth(0.30),
                2: const FractionColumnWidth(0.20),
              },
              children: [
                TableRow(
                  children: [
                    Container(
                      height: rowHeight,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'VALEURS NUTRITIONELLES',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: rowHeight,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          widget.product.servingSize.isNotEmpty
                              ? 'Par portion (${widget.product.servingSize})'
                                  .toUpperCase()
                              : 'Par portion (N/A)',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: rowHeight,
                      decoration: BoxDecoration(color: Colors.grey[100]),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'AJR*',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                for (var entry in entries)
                  // Je n'affiche que les nutriments élligibles aux ajr
                  if (provider.ajrValues.containsKey(entry.key))
                    TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                      ),
                      children: [
                        Container(
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              provider.ajrValues[entry.key]?['name'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[900],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              "${entry.value.toStringAsFixed(0)} ${widget.product.nutriments[entry.key.replaceAll('_serving', '_unit')]}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(color: Colors.grey[100]),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              (double.tryParse(entry.value.toString()) !=
                                          null &&
                                      provider.ajrValues[entry.key] != null)
                                  ? ('${(((double.parse(entry.value.toString())) / provider.ajrValues[entry.key]?['value']!) * 100).toStringAsFixed(0)}%')
                                  : '—',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Ajr* : Apports Journaliers Recommandés',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
