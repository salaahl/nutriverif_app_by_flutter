import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Scores extends StatelessWidget {
  const Scores({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: Theme.of(context).textTheme.displayLarge!,
            children: [
              TextSpan(text: 'Votre alimentation '),
              TextSpan(
                text: 'décryptée',
                style: TextStyle(color: Colors.redAccent),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/images/nutriscore-a.svg",
                width: 160,
                semanticsLabel: 'Image du Nutriscore',
              ),
              const SizedBox(height: 16),
              const Text(
                "Le Nutri-Score est un système d'étiquetage nutritionnel qui aide les consommateurs à identifier la qualité nutritionnelle des aliments. "
                "Il classe les produits de A (meilleure qualité nutritionnelle) à E (moins favorable), en prenant en compte des critères tels que les "
                "nutriments bénéfiques (fibres, protéines) et les éléments à limiter (sucre, sel). Ce score, accompagné de couleurs, permet de faire des choix alimentaires plus éclairés.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/nova-group-1.svg',
                width: 40,
                semanticsLabel: 'Image du Nova score',
              ),
              const SizedBox(height: 16),
              const Text(
                "Le système NOVA évalue le degré de transformation des aliments plutôt que leur valeur nutritionnelle directe. Il classe les produits en quatre groupes, allant des aliments bruts ou peu transformés (groupe 1) aux produits ultratransformés (groupe 4). Ce système met en avant l'importance de privilégier les aliments naturels et peu modifiés pour une alimentation plus saine.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
