import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

import 'package:app_nutriverif/providers/products_provider.dart';

class AppSearchBar extends StatefulWidget {
  final bool showFilters;
  final VoidCallback? onReset;

  const AppSearchBar({super.key, this.showFilters = false, this.onReset});

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late ProductsProvider _provider;
  late TextEditingController _searchController;

  final Map<String, String> _filters = {
    'Pertinence': 'popularity_key',
    'Nom': 'product_name',
    'Date de création': 'created_t',
    'Nutriscore': 'nutriscore_score',
    'Nova Score': 'nova_score',
  };

  @override
  void initState() {
    super.initState();
    _provider = context.read<ProductsProvider>();
    _searchController = TextEditingController(text: _provider.input);
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _provider = context.watch<ProductsProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Un nom de produit, une marque ou une categorie...',
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  prefixIcon: IconButton(
                    padding: const EdgeInsets.only(
                      left: 12,
                    ), // rééquilibrage avec le padding appliqué sur le TextField
                    icon: Icon(
                      Icons.qr_code_rounded,
                      color: Colors.grey,
                      semanticLabel: 'Rechercher un produit par code-barres',
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/scanner'),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(156, 163, 175, 1),
                      width: 4.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(229, 231, 235, 1),
                      width: 4.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999.0),
                    borderSide: const BorderSide(
                      color: Color(0xFF9CA3AF),
                      width: 4.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 12.0,
                  ),
                ),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: Colors.black87),
              ),
            ),
            IconButton(
              padding: const EdgeInsets.only(left: 8),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[800],
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                  semanticLabel: 'Rechercher',
                ),
              ),
              onPressed: () async {
                final input = _searchController.text.trim();
                FocusScope.of(context).unfocus();

                if (input.isEmpty || input.length < 2) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Center(
                        child: Text(
                          'Veuillez entrer un nom de produit valide',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  if (widget.onReset != null) widget.onReset!();

                  await _provider.searchProducts(
                    query: input,
                    selected: _provider.filter,
                    method: 'complete',
                  );

                  if (_provider.products.isEmpty && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(
                          child: Text(
                            _provider.error != null
                                ? 'Une erreur est survenue'
                                : 'Aucun produit trouvé',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        widget.showFilters
            ? Wrap(
              spacing: 12,
              runSpacing: 12,
              children:
                  _filters.entries.map((filter) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _provider.setFilter(filter.value);
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              _provider.filter == filter.value
                                  ? customGreen
                                  : Colors.grey,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          filter.key,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            )
            : const SizedBox.shrink(),
      ],
    );
  }
}
