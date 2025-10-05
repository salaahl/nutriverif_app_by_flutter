import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:provider/provider.dart';

import 'package:app_nutriverif/providers/products_provider.dart';

import 'package:app_nutriverif/views/widgets/product_card/product_card.dart';

// Child de la grid de produits. Contient la logique d'affichage
class OptimizedProductItem extends StatelessWidget {
  final dynamic product;
  final int index;

  const OptimizedProductItem({
    super.key,
    required this.product,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductsProvider>();
    final productCard = ProductCard(product: product, widthAjustment: 64);

    return provider.hasAnimatedId('${product.id}_product')
        ? productCard
        : VisibilityDetector(
          key: Key('${product.id}_product'),
          onVisibilityChanged: (info) {
            // Le modulo (%) retourne le reste de la division, ce qui permet de réinitialiser la cascade toutes les deux cartes
            final cascadeIndex = index % 2;
            Future.delayed(Duration(milliseconds: cascadeIndex * 200), () {
              if (info.visibleFraction >= 0.20) {
                provider.addAnimatedId('${product.id}_product');
              }
            });
          },
          child: _AnimatedProductCard(
            key: ValueKey('${product.id}_product'),
            child: productCard,
          ),
        );
  }
}

class _AnimatedProductCard extends StatelessWidget {
  final Widget child;

  const _AnimatedProductCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Selector<ProductsProvider, bool>(
      selector:
          (_, provider) => provider.hasAnimatedId('${(key as ValueKey).value}'),
      builder: (context, hasAnimated, _) {
        return TweenAnimationBuilder<double>(
          tween: Tween(
            begin: hasAnimated ? 1.0 : 0.0,
            end: hasAnimated ? 1.0 : 0.0,
          ),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: child,
        );
      },
    );
  }
}
