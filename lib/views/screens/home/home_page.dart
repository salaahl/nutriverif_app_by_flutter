import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';
import 'package:app_nutriverif/core/services/products_service.dart';
import 'package:app_nutriverif/core/services/mock_products_service.dart';
import 'package:app_nutriverif/providers/products_provider.dart';

import '../../widgets/app_container.dart';
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

  final _service = isLocal ? MockProductsService() : ProductsService();
  final ValueNotifier<Set<String>> _visibleSections =
      ValueNotifier<Set<String>>({});

  bool _isInitialized = false;

  final List<String> categories = [
    'yaourts',
    'céréales',
    'boissons',
    'snacks',
    'plats préparés',
    'bio',
    'sans gluten',
  ];

  void searchSuggestedProducts() async {
    try {
      final ProductsProvider provider = context.read<ProductsProvider>();
      final product = provider.productDemo;

      if (provider.productDemo.id.isEmpty) return;

      _service
          .fetchSuggestedProducts(
            id: product.id,
            brand: product.brand,
            name: product.name,
            categories: product.categories,
            nutriscore: product.nutriscore,
            nova: product.nova,
          )
          .then((suggestedProducts) {
            provider.setSuggestedProductsDemo(suggestedProducts);
          });
    } catch (e) {
      debugPrint('Erreur lors du chargement des produits suggérés: $e');
    }
  }

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

      final productDemo = await _service.fetchProductById(
        '3608580758686',
        complete: true,
      );
      provider.setProductDemo(productDemo);

      _isInitialized = true;
    } catch (e) {
      debugPrint('Erreur lors du chargement des produits: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final actualWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverPadding(
            padding:
                actualWidth > maxWidth + screenPadding.left * 2
                    ? const EdgeInsets.symmetric(horizontal: 0)
                    : screenPadding,
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                AppContainer(
                  child: Column(
                    children: [
                      myAppBar(context, route: '/'),
                      const SizedBox(height: 20),
                      _buildTitle(),
                      const SizedBox(height: 60),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          child: Container(
                            padding: const EdgeInsets.only(top: 16),
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: Alignment.center,
                                radius: 1,
                                colors: [
                                  Color.fromRGBO(255, 255, 255, 0.75),
                                  Color.fromRGBO(255, 255, 255, 0.15),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              // ...
                            ),
                            child: Padding(
                              padding:
                                  actualWidth > maxWidth
                                      ? const EdgeInsets.all(32)
                                      : const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 32,
                                      ),
                              child: Column(
                                children: [
                                  const AppSearchBar(),
                                  const SizedBox(height: 16),
                                  if (categories.isNotEmpty &&
                                      !context
                                          .read<ProductsProvider>()
                                          .productsIsLoading)
                                    Transform.translate(
                                      offset: const Offset(0, -5),
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 48,
                                        ),

                                        child: Wrap(
                                          alignment: WrapAlignment.center,
                                          spacing: 8,
                                          runSpacing: 8,
                                          children:
                                              categories.map((category) {
                                                return IgnorePointer(
                                                  ignoring:
                                                      context
                                                          .read<
                                                            ProductsProvider
                                                          >()
                                                          .productsIsLoading,
                                                  child: Material(
                                                    color: const Color.fromARGB(
                                                      255,
                                                      52,
                                                      58,
                                                      64,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          999,
                                                        ),
                                                    child: InkWell(
                                                      onTap:
                                                          () => context
                                                              .read<
                                                                ProductsProvider
                                                              >()
                                                              .searchProducts(
                                                                query: category,
                                                                method:
                                                                    'complete',
                                                              ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            999,
                                                          ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 8,
                                                            ),
                                                        child: Text(
                                                          category,
                                                          style:
                                                              const TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                        ),
                                      ),
                                    ),
                                  Selector<ProductsProvider, bool>(
                                    selector:
                                        (_, provider) =>
                                            provider.productsIsLoading,
                                    builder: (context, isLoading, _) {
                                      final hasProducts =
                                          context
                                              .read<ProductsProvider>()
                                              .products
                                              .isNotEmpty;

                                      if (isLoading || hasProducts) {
                                        return SearchProductsResults();
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                  _buildProductCount(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                      const LazyYoutubePlayer(),
                      const SizedBox(height: 32),
                      _buildAboutSection(),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ]),
            ),
          ),

          SliverPadding(
            padding:
                actualWidth > maxWidth + screenPadding.left * 2
                    ? const EdgeInsets.symmetric(horizontal: 0)
                    : screenPadding,
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
            padding: actualWidth > maxWidth ? screenPadding * 2 : screenPadding,
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
              color: customGreen,
              fontFamily: 'Grand Hotel',
              fontSize: Theme.of(context).textTheme.titleLarge!.fontSize! * 2,
              fontWeight: FontWeight.w300,
            ),
            children: [
              TextSpan(text: 'Vérif', style: TextStyle(color: Colors.black)),
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
              backgroundColor: Color.fromRGBO(255, 82, 82, 0.8),
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
