import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

import '../widgets/app_bar.dart';

class LegalNoticePage extends StatelessWidget {
  const LegalNoticePage({super.key});

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Impossible d\'ouvrir $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: screenPadding,
        children: [
          myAppBar(context),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.5,
                      color: Colors.black,
                    ),
                    text: 'MENTIONS ',
                    children: [
                      TextSpan(
                        text: 'LÉGALES',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        letterSpacing: 0.4,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Le site NutriVérif est édité par ',
                        ),
                        TextSpan(
                          text: 'Salaha Sokhona',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            decorationThickness: 4,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  _launchURL(
                                    'https://www.linkedin.com/in/salaha-sokhona/',
                                  );
                                },
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Les serveurs sont gérés par la société Render, Inc.\n'
                    'Siège social de Render : 340 S Lemon Ave #7160, Walnut, CA 91789, États-Unis\n'
                    'Les serveurs sont situés au sein de l\'Union européenne, conformément aux obligations de protection des données personnelles.\n'
                    'Courriel : privacy@render.com\n'
                    'Pour tout contact, veuillez utiliser le formulaire de contact disponible sur leur site officiel : https://render.com',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Le site utilise des cookies essentiels au bon fonctionnement du site. Ces cookies ne collectent '
                    'pas de données personnelles et sont utilisés uniquement dans le but d\'améliorer l\'expérience de '
                    'navigation de l\'utilisateur.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Les présentes mentions légales sont régies par le droit français. En cas de litige, les '
                    'tribunaux français seront seuls compétents.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        height: 1.4,
                        letterSpacing: 0.4,
                      ),
                      children: [
                        const TextSpan(
                          text:
                              'NutriVérif s\'appuyant sur la base de données d\'',
                        ),
                        TextSpan(
                          text: 'Open Food Facts',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            decorationThickness: 4,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  _launchURL(
                                    'https://fr.openfoodfacts.org/conditions-d-utilisation',
                                  );
                                },
                        ),
                        const TextSpan(
                          text:
                              ', l\'accès ou l\'utilisation du site ou de ses services valent également acceptation sans réserve des ',
                        ),
                        TextSpan(
                          text: 'mentions légales',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            decorationThickness: 4,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  _launchURL(
                                    'https://fr.openfoodfacts.org/mentions-legales',
                                  );
                                },
                        ),
                        const TextSpan(text: ' et des '),
                        TextSpan(
                          text: 'conditions générales d\'utilisation',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            decorationThickness: 4,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  _launchURL(
                                    'https://fr.openfoodfacts.org/conditions-d-utilisation',
                                  );
                                },
                        ),
                        const TextSpan(text: ' d\'Open Food Facts.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }
}
