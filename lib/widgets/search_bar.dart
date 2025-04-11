import 'package:flutter/material.dart';
import 'package:app_nutriverif/providers/products_provider.dart';

class AppSearchBar extends StatefulWidget {
  final ProductsProvider provider;

  const AppSearchBar({super.key, required this.provider});

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late TextEditingController _searchController;

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
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            autofocus:
                ModalRoute.of(context)!.settings.name == '/products'
                    ? true
                    : false,
            decoration: InputDecoration(
              hintText: 'Entrez un nom de produit, un code-barres...',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 16.0, right: 8.0),
                child: Icon(Icons.search, color: Colors.grey),
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
            child: const Icon(Icons.search, color: Colors.white),
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
              final result = await Navigator.pushNamed(
                context,
                "/product",
                arguments: input,
              );

              if (context.mounted && result != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      result.toString(),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            } else {
              await widget.provider.searchProducts(
                userInput: input,
                method: 'complete',
              );

              if (widget.provider.products.isEmpty) {
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
    );
  }
}
