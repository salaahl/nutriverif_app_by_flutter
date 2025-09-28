import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

import '../widgets/app_bar.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  void _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Impossible d\'ouvrir $url';
      }
    } catch (e) {
      debugPrint('Erreur lors de l\'ouverture de l\'URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final customStyles = {
      'textColor': Colors.redAccent,
      'arrowColor': const Color.fromRGBO(255, 255, 255, 0.35),
    };

    return Scaffold(
      body: Container(
        padding: screenPadding,
        decoration: const BoxDecoration(color: customGreen),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                myAppBar(context, customStyles: customStyles),
                const SizedBox(height: 16),
                _buildTitle(context),
                const SizedBox(height: 8),
                _buildAnimatedSubtitle(),
                const SizedBox(height: 24),
                _buildMainDescription(context),
                const SizedBox(height: 32),
                _buildOpenFoodFactsDescription(context),
                const SizedBox(height: 64),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'À PROPOS DE NOUS',
      style: Theme.of(context).textTheme.titleMedium,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAnimatedSubtitle() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeInOutCubicEmphasized,
      duration: const Duration(milliseconds: 2500),
      builder: (context, value, child) {
        return Column(
          children: [
            SizedBox(
              height: 20, // Hauteur fixe pour éviter les sauts visuels
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Text(
                    '(et un peu d\'Open Food Facts)',
                    textAlign: TextAlign.center,
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      height: 4,
                      width: 200 * value,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 82, 82, 0.75),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMainDescription(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text:
            'NutriVérif est une application web de food checking alimentée par la base de données d\'Open Food Facts et développée par ',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.black,
          height: 1.4,
          letterSpacing: 0.5,
        ),
        children: [
          _buildLinkTextSpan(
            'Salaha Sokhona',
            'https://www.linkedin.com/in/salaha-sokhona/',
          ),
          const TextSpan(
            text:
                '. Elle résulte d\'une volonté de pouvoir vérifier la composition de ses aliments par le biais d\'une application simple, '
                'ne requiérant pas d\'inscription et fournissant le strict minimum de fonctionnalités. Elle liste les produits alimentaires avec leurs ingrédients, '
                'valeurs nutritionnelles et autres juteuses informations que l\'on peut trouver sur les labels de ces produits.',
          ),
        ],
      ),
    );
  }

  Widget _buildOpenFoodFactsDescription(BuildContext context) {
    return Text(
      'Open Food Facts est une association à but non-lucratif composée de volontaires. Plus de 100.000 contributeurs comme vous ont ajouté plus de 3 000 000 '
      'produits de 150 pays. Les données sur la nourriture sont d\'intérêt public et doivent être libres et ouvertes. La base de données complète est publiée en open data '
      'et peut être réutilisée par quiconque et pour n\'importe quel usage.',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Colors.black,
        height: 1.4,
        letterSpacing: 0.5,
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
