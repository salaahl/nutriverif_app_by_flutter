import 'package:flutter/material.dart';

Widget customAppBar() {
  return AppBar(
    title: Stack(
      children: [
        // Icone de retour en position absolue
        Positioned(
          left: 0,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 40),
            onPressed: () {
              // Navigator.pop(context);
            },
          ),
        ),

        // Contenu centré
        Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 80,
                width: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              const Text.rich(
                TextSpan(
                  text: 'Nutri',
                  style: TextStyle(
                    fontFamily: 'Grand Hotel',
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                  ),
                  children: [
                    TextSpan(
                      text: 'Vérif',
                      style: TextStyle(
                        fontFamily: 'Grand Hotel',
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                        color: Color.fromRGBO(0, 189, 126, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
