import 'package:flutter/material.dart';
import 'package:app_nutriverif/providers/products_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSearchBar extends StatefulWidget {
  final ProductsProvider provider;
  final bool showFilters;

  const AppSearchBar({
    super.key,
    required this.provider,
    this.showFilters = false,
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late TextEditingController _searchController;
  final Map<String, String> _filters = {
    'Popularité': 'popularity_key',
    'Nom': 'product_name',
    'Date de création': 'created_t',
    'Nutriscore': 'nutriscore_score',
    'Nova Score': 'nova_score',
  };

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.provider.input);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Entrez un nom de produit, un code-barres...',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: Padding(
                    // La valeur "top" réequilibre le décalage apporté par le viewport
                    padding: EdgeInsets.only(top: 6, left: 20, right: 6),
                    child: SvgPicture.string(
                      '''
                      <svg data-v-e8019d2a="" id="search-bar-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 560 640">
                        <path data-v-e8019d2a="" d="M416 0C400 0 288 32 288 176V288c0 35.3 28.7 64 64 64h32V480c0 17.7 14.3 32 32 32s32-14.3 32-32V352 240 32c0-17.7-14.3-32-32-32zM64 16C64 7.8 57.9 1 49.7 .1S34.2 4.6 32.4 12.5L2.1 148.8C.7 155.1 0 161.5 0 167.9c0 45.9 35.1 83.6 80 87.7V480c0 17.7 14.3 32 32 32s32-14.3 32-32V255.6c44.9-4.1 80-41.8 80-87.7c0-6.4-.7-12.8-2.1-19.1L191.6 12.5c-1.8-8-9.3-13.3-17.4-12.4S160 7.8 160 16V150.2c0 5.4-4.4 9.8-9.8 9.8c-5.1 0-9.3-3.9-9.8-9L127.9 14.6C127.2 6.3 120.3 0 112 0s-15.2 6.3-15.9 14.6L83.7 151c-.5 5.1-4.7 9-9.8 9c-5.4 0-9.8-4.4-9.8-9.8V16zm48.3 152l-.3 0-.3 0 .3-.7 .3 .7z"></path>
                      </svg>
                      ''',
                      width: 6,
                      colorFilter: ColorFilter.mode(
                        Colors.grey[600]!,
                        BlendMode.srcIn,
                      ),
                    ),
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
                style: const TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ),
            IconButton(
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

                // Validation
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
                }

                // Recherche par code-barres
                if (RegExp(r'^\d{8,13}$').hasMatch(input)) {
                  final product = await widget.provider.fetchProductById(input);

                  if (product.id.isNotEmpty && context.mounted) {
                    Navigator.pushNamed(
                      context,
                      "/product",
                      arguments: product,
                    );
                  }
                } else {
                  widget.provider.setProducts(
                    await widget.provider.searchProductsByQuery(
                      query: input,
                      selected: widget.provider.filter,
                      method: 'complete',
                    ),
                  );

                  if (widget.provider.products.isEmpty && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Center(
                          child: Text(
                            'Aucun produit trouvé',
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
        const SizedBox(height: 8),
        widget.showFilters
            ? Wrap(
              spacing: 12,
              children:
                  _filters.entries.map((filter) {
                    return Material(
                      child: FilterChip(
                        label: Text(filter.key),
                        selected: filter.value == widget.provider.filter,
                        onSelected: (s) {
                          setState(() {
                            widget.provider.setFilter(filter.value);
                          });
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
                    );
                  }).toList(),
            )
            : SizedBox.shrink(),
      ],
    );
  }
}
