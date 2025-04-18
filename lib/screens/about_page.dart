import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(0, 189, 126, 1)),
        child: ListView(
          children: [
            myAppBar(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(height: 48),
                  Text(
                    'A PROPOS DE NOUS',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '(et un peu d\'Open Food Facts)',
                    style: TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      decorationThickness: 4,
                      decorationColor: const Color.fromRGBO(255, 82, 82, 0.75),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'NutriVérif est une application web de food checking alimentée par la base de données d\'Open Food Facts et développée par '
                      'Salaha Sokhona. Elle résulte d\'une volonté de pouvoir vérifier la composition de ses aliments par le biais d\'une application simple, '
                      'ne requiérant pas d\'inscription et fournissant le strict minimum de fonctionnalités. Elle liste les produits alimentaires avec leurs ingrédients, '
                      'valeurs nutritionnelles et autres juteuses informations que l\'on peut trouver sur les labels de ces produits.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16), // espacement
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Open Food Facts est une association à but non-lucratif composée de volontaires. Plus de 100.000 contributeurs comme vous ont ajouté plus de 3 000 000 '
                      'produits de 150 pays. Les données sur la nourriture sont d\'intérêt public et doivent être libres et ouvertes. La base de données complète est publiée en open data '
                      'et peut être réutilisée par quiconque et pour n\'importe quel usage.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
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

  // Helper pour ouvrir un lien externe (par exemple LinkedIn)
  void launchUrl(String url) {
    // Utiliser la librairie url_launcher pour ouvrir un lien
    // launch(url);
  }
}
