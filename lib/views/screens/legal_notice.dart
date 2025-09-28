import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

import '../widgets/app_bar.dart';

class LegalNoticePage extends StatelessWidget {
  const LegalNoticePage({super.key});

  void _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Impossible d\'ouvrir $url';
      }
    } catch (e) {
      // Gérer l'erreur silencieusement ou afficher un message
      debugPrint('Erreur lors de l\'ouverture de l\'URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ajouter une couleur de fond explicite pour éviter le flash
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: screenPadding,
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                myAppBar(context),
                _buildTitle(context),
                const SizedBox(height: 32),
                _buildEditorInfo(context),
                const SizedBox(height: 32),
                _buildCookiesInfo(context),
                const SizedBox(height: 32),
                _buildJurisdictionInfo(context),
                const SizedBox(height: 32),
                _buildOpenFoodFactsInfo(context),
                const SizedBox(height: 64),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.titleMedium,
        text: 'MENTIONS ',
        children: const [
          TextSpan(text: 'LÉGALES', style: TextStyle(color: Colors.redAccent)),
        ],
      ),
    );
  }

  Widget _buildEditorInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: RichText(
        textAlign: TextAlign.center,
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
                    ..onTap =
                        () => _launchURL(
                          'https://www.linkedin.com/in/salaha-sokhona/',
                        ),
            ),
            const TextSpan(text: '.'),
          ],
        ),
      ),
    );
  }

  Widget _buildCookiesInfo(BuildContext context) {
    return Text(
      'Le site utilise des cookies essentiels au bon fonctionnement du site. Ces cookies ne collectent '
      'pas de données personnelles et sont utilisés uniquement dans le but d\'améliorer l\'expérience de '
      'navigation de l\'utilisateur.',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget _buildJurisdictionInfo(BuildContext context) {
    return Text(
      'Les présentes mentions légales sont régies par le droit français. En cas de litige, les '
      'tribunaux français seront seuls compétents.',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget _buildOpenFoodFactsInfo(BuildContext context) {
    return RichText(
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
          _buildLinkTextSpan(
            'Open Food Facts',
            'https://fr.openfoodfacts.org',
          ),
          const TextSpan(
            text:
                ', l\'accès ou l\'utilisation du site ou de ses services valent également acceptation sans réserve des ',
          ),
          _buildLinkTextSpan(
            'mentions légales',
            'https://fr.openfoodfacts.org/mentions-legales',
          ),
          const TextSpan(text: ' et des '),
          _buildLinkTextSpan(
            'conditions générales d\'utilisation',
            'https://fr.openfoodfacts.org/conditions-d-utilisation',
          ),
          const TextSpan(text: ' d\'Open Food Facts.'),
        ],
      ),
    );
  }

  TextSpan _buildLinkTextSpan(String text, String url) {
    return TextSpan(
      text: text,
      style: const TextStyle(
        decoration: TextDecoration.underline,
        decorationThickness: 4,
      ),
      recognizer: TapGestureRecognizer()..onTap = () => _launchURL(url),
    );
  }
}
