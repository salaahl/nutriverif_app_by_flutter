import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

import 'package:app_nutriverif/providers/products_provider.dart';

import 'package:app_nutriverif/views/widgets/loader.dart';
import 'package:app_nutriverif/views/screens/product/widgets/product_image.dart';
import 'package:app_nutriverif/views/screens/product/widgets/product_name.dart';
import 'package:app_nutriverif/views/screens/product/widgets/product_scores.dart';
import 'package:app_nutriverif/views/screens/product/widgets/product_nutrients.dart';
import 'package:app_nutriverif/views/screens/product/widgets/product_alternatives.dart';

class FeaturedProduct extends StatefulWidget {
  const FeaturedProduct({super.key});

  @override
  State<FeaturedProduct> createState() => _FeaturedProductState();
}

class _FeaturedProductState extends State<FeaturedProduct> {
  late ProductsProvider _provider;

  @override
  void initState() {
    super.initState();

    _provider = context.read<ProductsProvider>();
  }

  final Set<String> _animatedProductIds = {};

  @override
  Widget build(BuildContext context) {
    return Container(
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
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 48),
          const Text.rich(
            TextSpan(
              text: "Vous méritez le meilleur pour votre alimentation",
              style: TextStyle(backgroundColor: Colors.redAccent),
              children: [
                TextSpan(
                  text: ". Si un produit a un Nutri-Score jugé trop faible :",
                  style: TextStyle(backgroundColor: Colors.transparent),
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
                    style: TextStyle(backgroundColor: Colors.redAccent),
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
                    !_animatedProductIds.contains('products_demo_arrow')) {
                  setState(() {
                    _animatedProductIds.add('products_demo_arrow');
                  });
                }
              },
              child: TweenAnimationBuilder<double>(
                tween: Tween(
                  begin:
                      _animatedProductIds.contains('products_demo_arrow')
                          ? 1.0
                          : 0.0,
                  end:
                      _animatedProductIds.contains('products_demo_arrow')
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
                  padding: const EdgeInsets.only(top: 48, bottom: 62),
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
                  style: TextStyle(backgroundColor: Colors.redAccent),
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
    );
  }
}
