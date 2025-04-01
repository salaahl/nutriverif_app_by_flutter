import 'package:flutter/material.dart';

Widget customAppBar([
  Color backgroundColor = Colors.transparent,
  Color titleColor = const Color.fromRGBO(0, 189, 126, 1),
]) {
  return AppBar(
    backgroundColor: backgroundColor,
    centerTitle: true, // S'assurer que la flèche n'affecte pas le centrage
    title:
        const SizedBox.shrink(), // On met un titre vide pour éviter les conflits
    flexibleSpace: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 80,
            width: 80,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 10),
          Text.rich(
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
                    color: titleColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
