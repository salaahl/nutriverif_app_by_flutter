import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';
import 'package:app_nutriverif/providers/products_provider.dart';

import '../../widgets/app_bar.dart';
import '../../widgets/loader.dart';
import './widgets/product_image.dart';
import './widgets/product_name.dart';
import './widgets/product_details.dart';
import './widgets/product_nutrients.dart';
import './widgets/product_scores.dart';
import './widgets/product_alternatives.dart';

class ProductPage extends StatefulWidget {
  final String id;
  final String image;
  final String lastUpdate;
  final String brand;
  final String name;
  final String nutriscore;
  final String nova;
  final List<String> categories;

  const ProductPage({
    super.key,
    required this.id,
    required this.image,
    required this.lastUpdate,
    required this.brand,
    required this.name,
    required this.nutriscore,
    required this.nova,
    required this.categories,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  late ProductsProvider _provider;
  late AnimationController _animationController;

  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: defaultAnimationTime,
      vsync: this,
    );

    _provider = context.read<ProductsProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeProduct();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  Future<void> _initializeProduct() async {
    if (!mounted) return;

    try {
      if (_provider.suggestedProducts.isNotEmpty) {
        _provider.suggestedProducts.clear();
      }

      await _provider.loadProductById(widget.id);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // Démarrer l'animation
      _animationController.forward();

      if (_shouldLoadSuggestions()) {
        _loadSuggestions();
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  // Retourne true si le produit devrait charger des suggestions au vu de son score
  bool _shouldLoadSuggestions() {
    return widget.nutriscore != 'a' || (int.tryParse(widget.nova) ?? 4) != 1;
  }

  Future<void> _loadSuggestions() async {
    try {
      await _provider.loadSuggestedProducts(
        id: widget.id,
        brand: widget.brand,
        name: widget.name,
        categories: widget.categories,
        nutriscore: widget.nutriscore,
        nova: widget.nova,
      );
    } catch (e) {
      debugPrint('Erreur lors du chargement des suggestions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: screenPadding,
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                myAppBar(context),
                _buildProductHeader(),
                if (_isLoading)
                  const Loader()
                else if (_hasError)
                  _buildErrorState(),
              ]),
            ),
          ),
          if (!_hasError) _buildSuccessState(),
        ],
      ),
    );
  }

  Widget _buildProductHeader() {
    return Hero(
      key: Key(widget.id),
      tag: widget.id,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductImage(image: widget.image),
          const SizedBox(height: 20),
          ProductName(
            brand: widget.brand,
            name: widget.name,
            lastUpdate: widget.lastUpdate,
          ),
          ProductScores(nutriscore: widget.nutriscore, nova: widget.nova),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Erreur lors du chargement',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _hasError = false;
                _errorMessage = null;
              });
              _animationController.reset();
              _initializeProduct();
            },
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Selector<ProductsProvider, bool>(
      selector: (_, provider) => provider.productIsLoading,
      builder: (context, isLoading, _) {
        return SliverToBoxAdapter(
          child: _AnimatedContent(
            animation: _animationController,
            categories: widget.categories,
          ),
        );
      },
    );
  }
}

class _AnimatedContent extends StatelessWidget {
  final Animation<double> animation;
  final List<String> categories;

  const _AnimatedContent({required this.animation, required this.categories});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductsProvider>();
    final product = provider.product;
    final suggestedProducts = provider.suggestedProducts;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 60 * (1 - animation.value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductNutrients(nutrients: product.nutrientLevels),
            ProductDetails(
              id: product.id,
              categories: categories,
              quantity: product.quantity,
              servingSize: product.servingSize,
              nutriments: product.nutriments,
              ingredients: product.ingredients,
              manufacturingPlace: product.manufacturingPlace,
              link: product.link,
            ),
            AlternativeProducts(products: suggestedProducts),
          ],
        ),
      ),
    );
  }
}
