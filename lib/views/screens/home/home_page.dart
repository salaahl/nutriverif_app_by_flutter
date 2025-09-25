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

class _HomePageState extends State<HomePage> {
  late ProductsProvider _provider;

  final _service = ProductsService();

  final Set<String> _animatedProductIds = {};

  Future<void> initProducts() async {
    _provider = context.read<ProductsProvider>();
    if (_provider.productDemo.id.isNotEmpty) return;

    _provider.setProductDemo(await _service.fetchProductById('3608580758686'));

    // Ne pas appeler setSuggestedProductsDemo si productDemo est vide
    if (_provider.productDemo.id.isEmpty) return;

    _provider.setSuggestedProductsDemo(
      await _service.fetchSuggestedProducts(
        id: _provider.productDemo.id,
        categories: _provider.productDemo.categories,
        nutriscore: _provider.productDemo.nutriscore,
        nova: _provider.productDemo.nova,
      ),
    );

    await _provider.loadLastProducts();
  }

  @override
  void initState() {
    super.initState();

    initProducts();
  }

  @override
  Widget build(BuildContext context) {
    _provider = context.watch<ProductsProvider>();

    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: screenPadding,
              child: Column(
                children: [
                  myAppBar(context, route: '/'),
                  const SizedBox(height: 20),
                  Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      text: 'Nutri',
                      style: TextStyle(
                        fontFamily: 'Grand Hotel',
                        fontSize: 60,
                        fontWeight: FontWeight.w300,
                      ),
                      children: [
                        TextSpan(
                          text: 'Vérif',
                          style: TextStyle(
                            fontFamily: 'Grand Hotel',
                            fontSize: 60,
                            fontWeight: FontWeight.w300,
                            color: customGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Manger (plus) sain',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w100),
                  ),
                  const SizedBox(height: 60),
                  AppSearchBar(),
                  const SizedBox(height: 16),
                  SearchProductsResults(),
                  const SizedBox(height: 35),
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [
                          Color.fromRGBO(87, 107, 128, 0.365),
                          Color.fromRGBO(47, 44, 54, 1),
                        ],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ).createShader(bounds);
                    },
                    child: const Text(
                      '+ de 4 034 279 produits référencés',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Grand Hotel',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color:
                            Colors
                                .white, // La couleur du texte sera "masquée" par le gradient
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  Row(children: [LazyYoutubePlayer()]),
                  const SizedBox(height: 32),
                  Column(
                    children: [
                      const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'NutriVérif est alimentée par "Open Food Facts", une base de données de produits alimentaires créée par tous et pour tous.',
                              style: TextStyle(
                                height: 1.4,
                                letterSpacing: 0.5,
                                backgroundColor: Color.fromRGBO(
                                  0,
                                  189,
                                  126,
                                  0.6,
                                ), // Applique le surlignage seulement sur le texte
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'Vous pouvez l\'utiliser pour faire de meilleurs choix alimentaires, et comme les données sont ouvertes, tout le monde peut les réutiliser pour tout usage.',
                              style: TextStyle(
                                height: 1.4,
                                letterSpacing: 0.5,
                                backgroundColor: Color.fromRGBO(
                                  0,
                                  189,
                                  126,
                                  0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/about');
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'En savoir plus',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/legal-notice',
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'Mentions légales',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                  VisibilityDetector(
                    key: Key('scores'),
                    onVisibilityChanged: (info) {
                      if (info.visibleBounds.height > 80 &&
                          !_animatedProductIds.contains('scores')) {
                        setState(() {
                          _animatedProductIds.add('scores');
                        });
                      }
                    },
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(
                        begin:
                            _animatedProductIds.contains('scores') ? 1.0 : 0.0,
                        end: _animatedProductIds.contains('scores') ? 1.0 : 0.0,
                      ),
                      curve: defaultAnimationCurve,
                      duration: defaultAnimationTime,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 120 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: const Scores(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
            VisibilityDetector(
              key: Key('featured_product'),
              onVisibilityChanged: (info) {
                if (info.visibleBounds.height > 120 &&
                    !_animatedProductIds.contains('featured_product')) {
                  setState(() {
                    _animatedProductIds.add('featured_product');
                  });
                }
              },
              child: TweenAnimationBuilder<double>(
                tween: Tween(
                  begin:
                      _animatedProductIds.contains('featured_product')
                          ? 1.0
                          : 0.0,
                  end:
                      _animatedProductIds.contains('featured_product')
                          ? 1.0
                          : 0.0,
                ),
                curve: defaultAnimationCurve,
                duration: defaultAnimationTime,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 240 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: FeaturedProduct(),
              ),
            ),
            const SizedBox(height: 80),
            VisibilityDetector(
              key: Key('last_products'),
              onVisibilityChanged: (info) {
                if (info.visibleBounds.height > 80 &&
                    !_animatedProductIds.contains('last_products')) {
                  setState(() {
                    _animatedProductIds.add('last_products');
                  });
                }
              },
              child: TweenAnimationBuilder<double>(
                tween: Tween(
                  begin:
                      _animatedProductIds.contains('last_products') ? 1.0 : 0.0,
                  end:
                      _animatedProductIds.contains('last_products') ? 1.0 : 0.0,
                ),
                curve: defaultAnimationCurve,
                duration: defaultAnimationTime,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 120 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: LastProducts(),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
