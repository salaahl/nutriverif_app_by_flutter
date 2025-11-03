import 'package:flutter/material.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

class AppContainer extends StatelessWidget {
  final Widget child;
  const AppContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
