import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

import 'package:app_nutriverif/providers/products_provider.dart';

class NutritionalTable extends StatefulWidget {
  final Map<String, dynamic> nutriments;
  final String servingSize;

  const NutritionalTable({
    super.key,
    required this.nutriments,
    required this.servingSize,
  });

  @override
  NutritionalTableState createState() => NutritionalTableState();
}

class NutritionalTableState extends State<NutritionalTable> {
  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductsProvider>();

    // Convertir l'objet en une liste de paires (nom, valeur)
    final entries = widget.nutriments.entries.toList();

    final double rowHeight = 85;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AjrButtonSelection(provider: provider, gender: 'women'),
            const SizedBox(width: 16),
            AjrButtonSelection(provider: provider, gender: 'men'),
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
                // En-tete du tableau
                TableRow(
                  children: [
                    Container(
                      height: rowHeight,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'VALEURS NUTRITIONELLES',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      height: rowHeight,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          widget.servingSize.isNotEmpty
                              ? 'Par portion (${widget.servingSize})'
                                  .toUpperCase()
                              : 'Par portion (N/A)',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      height: rowHeight,
                      decoration: BoxDecoration(color: Colors.grey[100]),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'AJR*',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                for (var entry in entries)
                  // Lignes du tableau. Je n'affiche que les nutriments élligibles aux ajr
                  if (provider.ajrValues.containsKey(entry.key))
                    _buildNutrientRow(
                      context,
                      entry.key,
                      entry.value,
                      provider.ajrValues,
                      widget.nutriments,
                    ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ajr* : Apports Journaliers Recommandés',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class AjrButtonSelection extends StatefulWidget {
  final ProductsProvider provider;
  final String gender;

  const AjrButtonSelection({
    super.key,
    required this.provider,
    required this.gender,
  });

  @override
  State<AjrButtonSelection> createState() => _AjrButtonSelectionState();
}

class _AjrButtonSelectionState extends State<AjrButtonSelection> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.provider.setAjrSelected(widget.gender);
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              widget.provider.ajrSelected == widget.gender
                  ? customGreen
                  : Colors.grey,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          widget.gender == 'women' ? 'femme' : 'homme',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

TableRow _buildNutrientRow(
  BuildContext context,
  String key,
  double value,
  Map<String, dynamic> ajrValues,
  Map<String, dynamic> nutriments,
) {
  return TableRow(
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
    ),
    children: [
      Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            ajrValues[key]?['name'],
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Colors.grey[900],
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            "${value.toStringAsFixed(0)} ${nutriments[key.replaceAll('_serving', '_unit')]}",
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: Colors.grey),
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(color: Colors.grey[100]),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            (double.tryParse(value.toString()) != null &&
                    ajrValues[key] != null)
                ? ('${((value / ajrValues[key]?['value']!) * 100).toStringAsFixed(0)}%')
                : '—',
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: Colors.grey),
          ),
        ),
      ),
    ],
  );
}
