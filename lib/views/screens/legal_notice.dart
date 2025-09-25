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
          Column(
            children: [
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.titleMedium,
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
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(letterSpacing: 0.5),
                    children: [
                      const TextSpan(text: 'Le site NutriVérif est édité par '),
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
              const SizedBox(height: 32),
              Text(
                'Le site utilise des cookies essentiels au bon fonctionnement du site. Ces cookies ne collectent '
                'pas de données personnelles et sont utilisés uniquement dans le but d\'améliorer l\'expérience de '
                'navigation de l\'utilisateur.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              Text(
                'Les présentes mentions légales sont régies par le droit français. En cas de litige, les '
                'tribunaux français seront seuls compétents.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.black,
                    height: 1.4,
                    letterSpacing: 0.5,
                  ),
                  children: [
                    const TextSpan(
                      text: 'NutriVérif s\'appuyant sur la base de données d\'',
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
            ],
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }
}
