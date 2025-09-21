import 'package:flutter/material.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

Widget myAppBar(
  BuildContext context, {
  String? route = '',
  Map<String, dynamic>? customStyles = const {
    'textColor': customGreen,
    'arrowColor': Colors.white,
  },
}) {
  // Permet de retourner un cacheWidth adapté à la résolution de l'écran
  int getCacheWidth(BuildContext context, double logicalWidth) {
    final ratio = MediaQuery.of(context).devicePixelRatio;
    return (logicalWidth * ratio).round();
  }

  return SafeArea(
    child: SizedBox(
      height: 172,
      width: double.infinity,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Spacer(flex: 1),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    appIcon,
                    height: 80,
                    width: 80,
                    cacheWidth: getCacheWidth(context, 80),
                  ),
                  const SizedBox(height: 4),
                  if (route != '/')
                    Text.rich(
                      TextSpan(
                        text: 'Nutri',
                        style: const TextStyle(
                          fontFamily: 'Grand Hotel',
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                        ),
                        children: [
                          TextSpan(
                            text: 'Vérif',
                            style: TextStyle(color: customStyles?['textColor']),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const Spacer(flex: 1),
            ],
          ),
          if (Navigator.canPop(context) && route != '/')
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: customStyles?['arrowColor'],
                        borderRadius: BorderRadius.all(Radius.circular(999)),
                      ),
                      child: const Icon(Icons.arrow_back),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}
