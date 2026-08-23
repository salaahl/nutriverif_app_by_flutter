import 'package:app_nutriverif/views/widgets/app_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';
import 'package:app_nutriverif/providers/products_provider.dart';

class AppSearchBar extends StatefulWidget {
  final bool showFilters;

  const AppSearchBar({super.key, this.showFilters = false});

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late ProductsProvider _provider;
  late TextEditingController _searchController;

  static const Map<String, String> _filters = {
    'Pertinence': '-popularity_key',
    'Complétude': '-completeness',
    'Date d\'ajout': '-created_t',
    'Nutriscore': 'nutriscore_score',
    'Groupe Nova': 'nova_group',
  };

  Future<void> _searchProducts() async {
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
      await _provider.searchProducts(
        query: input,
        selected: _provider.filter,
        method: 'complete',
      );

      if (_provider.products.isEmpty && mounted) {
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
  }

  @override
  void initState() {
    super.initState();
    _provider = context.read<ProductsProvider>();
    _searchController = TextEditingController(text: _provider.input);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: RepaintBoundary(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText:
                          'Un nom de produit, une marque ou une categorie...',
                      hintStyle: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: IconButton(
                        padding: const EdgeInsets.only(left: 12),
                        icon: const Icon(
                          Icons.qr_code_rounded,
                          color: Colors.grey,
                          semanticLabel:
                              'Rechercher un produit par code-barres',
                        ),
                        onPressed:
                            () => Navigator.pushNamed(context, '/scanner'),
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
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(999.0)),
                        borderSide: BorderSide(
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
                onPressed: _searchProducts,
              ),
            ],
          ),
          if (widget.showFilters) ...[
            const SizedBox(height: 12),
            Selector<ProductsProvider, String>(
              selector: (_, provider) => provider.filter,
              builder: (context, currentFilter, _) {
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children:
                      _filters.entries.map((filter) {
                        return SearchBarFilter(
                          label: filter.key,
                          isSelected: currentFilter == filter.value,
                          onTap:
                              () => context.read<ProductsProvider>().setFilter(
                                filter.value,
                              ),
                        );
                      }).toList(),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class SearchBarFilter extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SearchBarFilter({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? customGreen : Colors.grey,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
