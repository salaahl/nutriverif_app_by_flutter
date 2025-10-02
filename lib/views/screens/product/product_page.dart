import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';
import 'package:app_nutriverif/providers/products_provider.dart';

import 'package:app_nutriverif/models/model_products.dart';

import '../../widgets/app_bar.dart';
import '../../widgets/loader.dart';
import './widgets/product_image.dart';
import './widgets/product_name.dart';
import './widgets/product_details.dart';
import './widgets/product_nutrients.dart';
import './widgets/product_scores.dart';
import './widgets/product_alternatives.dart';

import 'package:app_nutriverif/core/services/products_service.dart';

import 'package:app_nutriverif/views/screens/products/products_page.dart';

class ProductPage extends StatefulWidget {
  final Product product;
  final String image;

  const ProductPage({super.key, required this.product, required this.image});

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

  static const novaDescription = {
    '1': 'Aliments non transformés / minimalement',
    '2': 'Ingrédients culinaires transformés',
    '3': 'Aliments transformés',
    '4': 'Produits ultra-transformés',
  };

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

      await _provider.loadProductById(widget.product.id);

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
    final product = _provider.product;
    return product.nutriscore != 'a' || (int.tryParse(product.nova) ?? 4) != 1;
  }

  Future<void> _loadSuggestions() async {
    try {
      await _provider.loadSuggestedProducts(
        id: _provider.product.id,
        name:
            '${_provider.product.brand.split(',')[0]} ${_provider.product.name}',
        categories: _provider.product.categories,
        nutriscore: _provider.product.nutriscore,
        nova: _provider.product.nova,
      );
    } catch (e) {
      debugPrint('Erreur lors du chargement des suggestions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = '';
    if (widget.product.lastUpdate.isNotEmpty) {
      final date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(widget.product.lastUpdate) * 1000,
      );
      formattedDate =
          'Dernière mise à jour : ${date.day}-${date.month}-${date.year}';
    }

    int getCacheWidth(BuildContext context, double logicalWidth) {
      final ratio = MediaQuery.of(context).devicePixelRatio;
      return (logicalWidth * ratio).round();
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: screenPadding,
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                myAppBar(context),
                AspectRatio(
                  aspectRatio: 1,
                  child: Hero(
                    key: Key(widget.product.id),
                    tag: widget.product.id,
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 32),
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(48),
                      ),
                      child:
                          widget.product.image.isEmpty
                              ? Image.asset(
                                appIcon,
                                width: 160,
                                cacheWidth: getCacheWidth(context, 160),
                                semanticLabel: 'Image du produit',
                              )
                              : Image.network(
                                widget.product.image,
                                width: 160,
                                cacheWidth: getCacheWidth(context, 160),
                                semanticLabel: 'Image du produit',
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    appIcon,
                                    width: 160,
                                    cacheWidth: getCacheWidth(context, 160),
                                    semanticLabel:
                                        'Image de remplacement (erreur réseau)',
                                  );
                                },
                              ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: "${widget.product.brand} - ",
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: customGreen,
                        ),
                        children: [
                          TextSpan(
                            text: widget.product.name,
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
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProductScore(
                        imageUrl:
                            "assets/images/nutriscore-${widget.product.nutriscore}.svg",
                        width: 85,
                        score: widget.product.nutriscore,
                      ),
                      const SizedBox(height: 8),
                      _ProductScore(
                        imageUrl:
                            "assets/images/nova-group-${widget.product.nova}.svg",
                        width: 25,
                        score: widget.product.nova,
                      ),
                      if (novaDescription.containsKey(widget.product.nova)) ...[
                        const SizedBox(height: 2),
                        Text(
                          '(${novaDescription[widget.product.nova] as String})',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
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
          child: _AnimatedContent(animation: _animationController),
        );
      },
    );
  }
}

class _AnimatedContent extends StatelessWidget {
  final Animation<double> animation;

  const _AnimatedContent({required this.animation});

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
              categories: product.categories,
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

class _ProductScore extends StatelessWidget {
  final String imageUrl;
  final double width;
  final String score;

  const _ProductScore({
    required this.imageUrl,
    required this.width,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: width),
      child: SvgPicture.asset(
        imageUrl,
        width: width,
        fit: BoxFit.cover,
        semanticsLabel: "Score $score",
      ),
    );
  }
}
