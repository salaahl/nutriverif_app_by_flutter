import 'package:flutter/material.dart';

Widget myAppBar(BuildContext context) {
  return SafeArea(
    child: SizedBox(
      height: 172,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Spacer(flex: 1),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png', height: 80, width: 80),
                  const SizedBox(height: 4),
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
                          style: const TextStyle(color: Color(0xFF00BD7E)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 1),
            ],
          ),
          if (Navigator.canPop(context)) // flèche si possible
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(999)),
                  ),
                  child: const Icon(Icons.arrow_back)),
                onPressed: () => Navigator.pop(context),
              ),
            ),
        ],
      ),
    ),
  );
}
