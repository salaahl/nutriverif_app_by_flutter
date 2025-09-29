import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:app_nutriverif/views/widgets/product_card/product_card.dart';

// Child de la grid de produits. Contient la logique d'affichage
class OptimizedProductItem extends StatelessWidget {
  final dynamic product;
  final int index;
  final ValueNotifier<bool> notifier;

  const OptimizedProductItem({
    super.key,
    required this.product,
    required this.index,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    final productCard = ProductCard(product: product, widthAjustment: 64);

    return VisibilityDetector(
      key: Key(product.id),
      onVisibilityChanged: (info) {
        // Le modulo (%) retourne le reste de la division, ce qui permet de réinitialiser la cascade toutes les deux cartes
        final cascadeIndex = index % 2;
        Future.delayed(Duration(milliseconds: cascadeIndex * 300), () {
          if (!notifier.value && info.visibleFraction >= 0.20) {
            notifier.value = true;
          }
        });
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: notifier,
        builder: (context, shouldAnimate, child) {
          return shouldAnimate
              ? _AnimatedProductCard(
                key: ValueKey('${product.id}_animated'),
                child: productCard,
              )
              : SizedBox(height: 280);
        },
      ),
    );
  }
}

class _AnimatedProductCard extends StatelessWidget {
  final Widget child;

  const _AnimatedProductCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: child,
    );
  }
}
