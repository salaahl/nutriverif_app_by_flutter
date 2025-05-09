import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

import 'package:app_nutriverif/core/services/products_service.dart';
import 'package:app_nutriverif/providers/products_provider.dart';

import '../../widgets/app_bar.dart';
import '../../widgets/loader.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/product_card.dart';
import './widgets/youtube_player.dart';

import 'package:app_nutriverif/views/screens/product/widgets/product_image.dart';
import 'package:app_nutriverif/views/screens/product/widgets/product_name.dart';
import 'package:app_nutriverif/views/screens/product/widgets/product_scores.dart';
import 'package:app_nutriverif/views/screens/product/widgets/product_nutrients.dart';
import 'package:app_nutriverif/views/screens/product/widgets/product_alternatives.dart';

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
                  AnimatedSize(
                    duration: defaultAnimationTime,
                    curve: defaultAnimationCurve,
                    child: Column(
                      children: [
                        Container(
                          height:
                              _provider.productsIsLoading ||
                                      _provider.products.isNotEmpty
                                  ? null
                                  : 0,
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child:
                              _provider.productsIsLoading
                                  ? const Loader()
                                  : Wrap(
                                    alignment: WrapAlignment.spaceBetween,
                                    spacing:
                                        MediaQuery.of(context).size.width /
                                        100 *
                                        4,
                                    children:
                                        _provider.products.take(4).map((
                                          product,
                                        ) {
                                          return ProductCard(
                                            product: product,
                                            widthAjustment: 32,
                                          );
                                        }).toList(),
                                  ),
                        ),
                        if (_provider.products.length > 3)
                          Container(
                            margin: const EdgeInsets.only(top: 16),
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/products');
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: const Color.fromRGBO(
                                  0,
                                  189,
                                  126,
                                  1,
                                ),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
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
                      '+ de 3 819 363 produits référencés',
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
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/about');
                            },
                            child: Text(
                              'En savoir plus',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 18),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                  VisibilityDetector(
                    key: Key('nutriscore_card'),
                    onVisibilityChanged: (info) {
                      if (info.visibleBounds.height > 80 &&
                          !_animatedProductIds.contains('nutriscore_card')) {
                        setState(() {
                          _animatedProductIds.add('nutriscore_card');
                        });
                      }
                    },
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(
                        begin:
                            _animatedProductIds.contains('nutriscore_card')
                                ? 1.0
                                : 0.0,
                        end:
                            _animatedProductIds.contains('nutriscore_card')
                                ? 1.0
                                : 0.0,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              style: Theme.of(context).textTheme.displayLarge!,
                              children: [
                                TextSpan(text: 'Votre alimentation '),
                                TextSpan(
                                  text: 'décryptée',
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 48),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.network(
                                  'https://static.openfoodfacts.org/images/attributes/dist/nutriscore-a.svg',
                                  width: 160,
                                  semanticsLabel: 'Image du Nutriscore',
                                  placeholderBuilder:
                                      (context) => SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Le Nutri-Score est un système d'étiquetage nutritionnel qui aide les consommateurs à identifier la qualité nutritionnelle des aliments. "
                                  "Il classe les produits de A (meilleure qualité nutritionnelle) à E (moins favorable), en prenant en compte des critères tels que les "
                                  "nutriments bénéfiques (fibres, protéines) et les éléments à limiter (sucre, sel). Ce score, accompagné de couleurs, permet de faire des choix alimentaires plus éclairés.",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  VisibilityDetector(
                    key: Key('nova_card'),
                    onVisibilityChanged: (info) {
                      if (info.visibleBounds.height > 60 &&
                          !_animatedProductIds.contains('nova_card')) {
                        setState(() {
                          _animatedProductIds.add('nova_card');
                        });
                      }
                    },
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(
                        begin:
                            _animatedProductIds.contains('nova_card')
                                ? 1.0
                                : 0.0,
                        end:
                            _animatedProductIds.contains('nova_card')
                                ? 1.0
                                : 0.0,
                      ),
                      curve: defaultAnimationCurve,
                      duration: defaultAnimationTime,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 80 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.network(
                              'https://static.openfoodfacts.org/images/attributes/dist/nova-group-1.svg',
                              width: 40,
                              semanticsLabel: 'Image du Nova score',
                              placeholderBuilder:
                                  (context) => SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Le système NOVA évalue le degré de transformation des aliments plutôt que leur valeur nutritionnelle directe. Il classe les produits en quatre groupes, allant des aliments bruts ou peu transformés (groupe 1) aux produits ultratransformés (groupe 4). Ce système met en avant l'importance de privilégier les aliments naturels et peu modifiés pour une alimentation plus saine.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
            VisibilityDetector(
              key: Key('product_demo'),
              onVisibilityChanged: (info) {
                if (info.visibleBounds.height > 160 &&
                    !_animatedProductIds.contains('product_demo')) {
                  setState(() {
                    _animatedProductIds.add('product_demo');
                  });
                }
              },
              child: TweenAnimationBuilder<double>(
                tween: Tween(
                  begin:
                      _animatedProductIds.contains('product_demo') ? 1.0 : 0.0,
                  end: _animatedProductIds.contains('product_demo') ? 1.0 : 0.0,
                ),
                curve: defaultAnimationCurve,
                duration: defaultAnimationTime,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 320 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text.rich(
                        TextSpan(
                          text: "Découvrez des ",
                          children: [
                            TextSpan(
                              text: "alternatives",
                              style: TextStyle(color: customGreen),
                            ),
                            TextSpan(text: " plus saines"),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayLarge!,
                      ),
                      const SizedBox(height: 48),
                      const Text.rich(
                        TextSpan(
                          text:
                              "Vous méritez le meilleur pour votre alimentation",
                          style: TextStyle(backgroundColor: Colors.redAccent),
                          children: [
                            TextSpan(
                              text:
                                  ". Si un produit a un Nutri-Score jugé trop faible :",
                              style: TextStyle(
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Présentation partielle d'un produit
                      if (_provider.productDemo.id.isEmpty)
                        Loader()
                      else ...[
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 32),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProductImage(
                                id: _provider.productDemo.id,
                                image: _provider.productDemo.image,
                              ),
                              ProductName(
                                lastUpdate: _provider.productDemo.lastUpdate,
                                brand: _provider.productDemo.brand,
                                name: _provider.productDemo.name,
                              ),
                              ProductScores(
                                nutriscore: _provider.productDemo.nutriscore,
                                nova: _provider.productDemo.nova,
                              ),
                              ProductNutrients(
                                nutrients: _provider.productDemo.nutrientLevels,
                              ),
                            ],
                          ),
                        ),
                        const Text.rich(
                          TextSpan(
                            text:
                                "Notre fonctionnalité intelligente vous propose instantanément des alternatives ",
                            children: [
                              TextSpan(
                                text: "mieux notées et tout aussi savoureuses",
                                style: TextStyle(
                                  backgroundColor: Colors.redAccent,
                                ),
                              ),
                              TextSpan(text: " :"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        VisibilityDetector(
                          key: Key('products_demo_arrow'),
                          onVisibilityChanged: (info) {
                            if (info.visibleBounds.height > 25 &&
                                !_animatedProductIds.contains(
                                  'products_demo_arrow',
                                )) {
                              setState(() {
                                _animatedProductIds.add('products_demo_arrow');
                              });
                            }
                          },
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(
                              begin:
                                  _animatedProductIds.contains(
                                        'products_demo_arrow',
                                      )
                                      ? 1.0
                                      : 0.0,
                              end:
                                  _animatedProductIds.contains(
                                        'products_demo_arrow',
                                      )
                                      ? 1.0
                                      : 0.0,
                            ),
                            curve: defaultAnimationCurve,
                            duration: defaultAnimationTime,
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, -30 * (1 - value)),
                                  child: child,
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Icon(
                                    Icons.arrow_downward_rounded,
                                    color: customGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _provider.suggestedProductsDemo.isEmpty
                            ? Padding(
                              padding: const EdgeInsets.only(
                                top: 48,
                                bottom: 62,
                              ),
                              child: Loader(),
                            )
                            : AlternativeProducts(
                              products: _provider.suggestedProductsDemo,
                            ),
                      ],
                      const Text.rich(
                        TextSpan(
                          text: "Trouvez des options ",
                          children: [
                            TextSpan(
                              text: "plus saines",
                              style: TextStyle(
                                backgroundColor: Color.fromRGBO(
                                  0,
                                  189,
                                  126,
                                  0.6,
                                ),
                              ),
                            ),
                            TextSpan(
                              text:
                                  " et faites de chaque choix un pas vers une meilleure santé.",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "Produits",
                          children: [
                            TextSpan(
                              text: " recemment ",
                              style: TextStyle(color: customGreen),
                            ),
                            TextSpan(text: "ajoutés"),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayLarge!,
                      ),
                      const SizedBox(height: 32),
                      AnimatedSize(
                        duration: defaultAnimationTime,
                        curve: defaultAnimationCurve,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child:
                              _provider.lastProductsIsLoading
                                  ? const Loader()
                                  : SizedBox(
                                    height:
                                        _provider.lastProducts.isNotEmpty ||
                                                _provider.lastProductsIsLoading
                                            ? null
                                            : 0,
                                    width: double.infinity,
                                    child: Wrap(
                                      alignment: WrapAlignment.spaceBetween,
                                      spacing:
                                          MediaQuery.of(context).size.width /
                                          100 *
                                          4,
                                      children:
                                          _provider.lastProducts.map((product) {
                                            return ProductCard(
                                              product: product,
                                              widthAjustment: 32,
                                            );
                                          }).toList(),
                                    ),
                                  ),
                        ),
                      ),
                      Center(
                        heightFactor: 1.5,
                        child: Image.asset(
                          appIcon,
                          height: 160,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
