import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';
import 'package:app_nutriverif/core/services/products_service.dart';
import 'package:app_nutriverif/providers/products_provider.dart';

import '../../widgets/app_bar.dart';
import '../../widgets/search_bar.dart';
import './widgets/youtube_player.dart';
import './widgets/search_products_results.dart';
import './widgets/featured_product.dart';
import './widgets/scores.dart';
import './widgets/last_products.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final _service = ProductsService();
  final ValueNotifier<Set<String>> _visibleSections =
      ValueNotifier<Set<String>>({});

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _initProducts();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _visibleSections.dispose();
    super.dispose();
  }

  Future<void> _initProducts() async {
    if (_isInitialized) return;

    try {
      final ProductsProvider provider = context.read<ProductsProvider>();

      if (provider.productDemo.id.isNotEmpty) {
        _isInitialized = true;
        return;
      }

      final productDemo = await _service.fetchProductById('3608580758686');
      provider.setProductDemo(productDemo);

      if (productDemo.id.isEmpty) return;

      await Future.wait([
        _service
            .fetchSuggestedProducts(
              id: productDemo.id,
              name: productDemo.name,
              categories: productDemo.categories,
              nutriscore: productDemo.nutriscore,
              nova: productDemo.nova,
            )
            .then((suggestedProducts) {
              provider.setSuggestedProductsDemo(suggestedProducts);
            }),
        provider.loadLastProducts(),
      ]);

      _isInitialized = true;
    } catch (e) {
      debugPrint('Erreur lors du chargement des produits: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverPadding(
            padding: screenPadding,
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                myAppBar(context, route: '/'),
                const SizedBox(height: 20),
                _buildTitle(),
                const SizedBox(height: 60),
                const AppSearchBar(),
                const SizedBox(height: 16),
                Selector<ProductsProvider, bool>(
                  selector: (_, provider) => provider.productsIsLoading,
                  builder: (context, isLoading, _) {
                    final hasProducts =
                        context.read<ProductsProvider>().products.isNotEmpty;

                    if (isLoading || hasProducts) {
                      return SearchProductsResults();
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 35),
                _buildProductCount(),
                const SizedBox(height: 80),
                const Row(children: [LazyYoutubePlayer()]),
                const SizedBox(height: 32),
                _buildAboutSection(),
                const SizedBox(height: 80),
              ]),
            ),
          ),

          SliverPadding(
            padding: screenPadding,
            sliver: _buildAnimatedSection(
              'scores',
              const Scores(),
              visibleHeight: 80,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),

          _buildAnimatedSection(
            'featured_product',
            FeaturedProduct(),
            visibleHeight: 120,
            offset: 240,
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),

          SliverPadding(
            padding: screenPadding,
            sliver: _buildAnimatedSection(
              'last_products',
              LastProducts(),
              visibleHeight: 80,
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            text: 'Nutri',
            style: TextStyle(
              fontFamily: 'Grand Hotel',
              fontSize: Theme.of(context).textTheme.titleLarge!.fontSize! * 2,
              fontWeight: FontWeight.w300,
            ),
            children: [
              TextSpan(text: 'Vérif', style: TextStyle(color: customGreen)),
            ],
          ),
        ),
        Text(
          'Manger (plus) sain',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildProductCount() {
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: [
            Color.fromRGBO(87, 107, 128, 0.365),
            Color.fromRGBO(47, 44, 54, 1),
          ],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ).createShader(bounds);
      },
      child: Text(
        '+ de 4 034 279 produits référencés',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
          fontFamily: 'Grand Hotel',
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      children: [
        const _HighlightedText(
          'NutriVérif est alimentée par "Open Food Facts", une base de données de produits alimentaires créée par tous et pour tous.',
        ),
        const SizedBox(height: 16),
        const _HighlightedText(
          'Vous pouvez l\'utiliser pour faire de meilleurs choix alimentaires, et comme les données sont ouvertes, tout le monde peut les réutiliser pour tout usage.',
        ),
        const SizedBox(height: 16),
        _buildActionButton('En savoir plus', '/about'),
        const SizedBox(height: 8),
        _buildActionButton('Mentions légales', '/legal-notice'),
      ],
    );
  }

  Widget _buildActionButton(String text, String route) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
          ),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, route),
            child: Row(
              children: [
                Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedSection(
    String sectionId,
    Widget child, {
    double visibleHeight = 80,
    double offset = 120,
  }) {
    final provider = context.read<ProductsProvider>();

    return SliverToBoxAdapter(
      child: VisibilityDetector(
        key: Key(sectionId),
        onVisibilityChanged: (info) {
          if (info.visibleBounds.height > visibleHeight) {
            provider.addAnimatedId('${sectionId}_section');
          }
        },
        child: _AnimatedSection(
          sectionId: '${sectionId}_section',
          offset: offset,
          child: child,
        ),
      ),
    );
  }
}

class _HighlightedText extends StatelessWidget {
  final String text;

  const _HighlightedText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text,
            style: const TextStyle(
              height: 1.5,
              letterSpacing: 0.5,
              backgroundColor: Color.fromRGBO(0, 189, 126, 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedSection extends StatelessWidget {
  final String sectionId;
  final double offset;
  final Widget child;

  const _AnimatedSection({
    required this.sectionId,
    required this.offset,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<ProductsProvider, bool>(
      selector: (_, provider) => provider.hasAnimatedId(sectionId),
      builder: (context, hasAnimated, _) {
        return TweenAnimationBuilder<double>(
          tween: Tween(
            begin: hasAnimated ? 1.0 : 0.0,
            end: hasAnimated ? 1.0 : 0.0,
          ),
          curve: defaultAnimationCurve,
          duration: defaultAnimationTime,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, offset * (1 - value)),
                child: child,
              ),
            );
          },
          child: child,
        );
      },
    );
  }
}
