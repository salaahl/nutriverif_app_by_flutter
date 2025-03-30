import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../widgets/my_app_bar.dart';
import '../widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'D1jzT02IBRA?si=gKqH8EWw5KYl42we', // ID de la vidéo YouTube
    flags: const YoutubePlayerFlags(autoPlay: false),
  );

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(172),
        child: customAppBar(),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.only(left: 16, right: 16),
          children: [
            const SizedBox(height: 80),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Nutri',
                      style: TextStyle(
                        fontFamily: 'Grand Hotel',
                        fontSize: 60,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const Text(
                      'Vérif',
                      style: TextStyle(
                        fontFamily: 'Grand Hotel',
                        fontSize: 60,
                        fontWeight: FontWeight.w300,
                        color: Color.fromRGBO(0, 189, 126, 1),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Manger (plus) sain',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 80),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText:
                              'Entrez un nom de produit, un code-barres, une marque ou un type d\'aliment',
                          hintStyle: const TextStyle(
                            color:
                                Colors.grey, // Texte gris pour le placeholder
                            fontSize: 14,
                          ),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 16.0, right: 8.0),
                            child: Icon(Icons.search, color: Colors.grey),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(999.0),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(156, 163, 175, 1),
                              width: 4.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(999.0),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(229, 231, 235, 1),
                              width: 4.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(999.0),
                            borderSide: const BorderSide(
                              color: Color(0xFF9CA3AF), // focus:border-gray-400
                              width: 4.0,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, // p-2.5
                            horizontal: 12.0, // px-12
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.black87, // text-gray-900
                          fontSize: 14, // text-sm
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Résultats de recherche")],
                ),
              ],
            ),
            const SizedBox(height: 35),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          colors: [
                            Color.fromRGBO(87, 107, 128, 0.365),
                            Color.fromRGBO(47, 44, 54, 1),
                          ], // Dégradé de couleurs
                          begin:
                              Alignment
                                  .centerRight, // Début du gradient à droite
                          end: Alignment.centerLeft, // Fin du gradient à gauche
                        ).createShader(bounds);
                      },
                      child: const Text(
                        '+ de 1 082 462 produits référencés',
                        style: TextStyle(
                          fontFamily: 'Grand Hotel',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color:
                              Colors
                                  .white, // La couleur du texte sera "masquée" par le gradient
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 80),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: YoutubePlayer(
                          controller: _controller,
                          showVideoProgressIndicator: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'NutriVérif est alimentée par "Open Food Facts", une base de données de produits alimentaires créée par tous et pour tous.',
                              style: TextStyle(
                                backgroundColor: Color.fromRGBO(
                                  0,
                                  189,
                                  126,
                                  0.6,
                                ), // Applique le surlignage seulement sur le texte
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'Vous pouvez l\'utiliser pour faire de meilleurs choix alimentaires, et comme les données sont ouvertes, tout le monde peut les réutiliser pour tout usage.',
                              style: TextStyle(
                                backgroundColor: Color.fromRGBO(
                                  0,
                                  189,
                                  126,
                                  0.6,
                                ), // Applique le surlignage seulement sur le texte
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/about');
                      },
                      child: Text('En savoir plus'),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 80),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        style: TextStyle(fontSize: 24),
                        children: [
                          TextSpan(text: 'Votre alimentation '),
                          TextSpan(
                            text: 'décryptée',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/logo.png', width: 160),
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
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/logo.png', width: 40),
                            const SizedBox(height: 16),
                            Text(
                              "Le système NOVA évalue le degré de transformation des aliments plutôt que leur valeur nutritionnelle directe. Il classe les produits en quatre groupes, allant des aliments bruts ou peu transformés (groupe 1) aux produits ultratransformés (groupe 4). Ce système met en avant l'importance de privilégier les aliments naturels et peu modifiés pour une alimentation plus saine.",
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ), // Explication des scores
            const SizedBox(height: 80),
            Column(
              children: [
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: const Text.rich(
                        TextSpan(
                          text: "Découvrez des ",
                          children: [
                            TextSpan(
                              text: "alternatives",
                              style: TextStyle(color: Color(0xFF00BD7E)),
                            ),
                            TextSpan(text: " plus saines"),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                Row(
                  children: [
                    Expanded(
                      child: const Text.rich(
                        TextSpan(
                          text:
                              "Vous méritez le meilleur pour votre alimentation",
                          style: TextStyle(backgroundColor: Color(0xFF00BD7E)),
                          children: [
                            TextSpan(
                              text:
                                  ". Si un produit a un Nutri-Score jugé trop faible :",
                              style: TextStyle(
                                backgroundColor: Color.fromRGBO(
                                  245,
                                  245,
                                  245,
                                  1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 160,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: "Nutella, Ferrero - ",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF00BD7E),
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      "Biscuit fourré à la pâte à tartiner aux noisettes et au cacao Nutella",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(children: [Text("Dernière mise à jour : 22/03/2025")]),
                    const SizedBox(height: 8),
                    // Nutriscore
                    Row(
                      children: [
                        Container(
                          width:
                              double
                                  .infinity, // Prend toute la largeur possible
                          constraints: BoxConstraints(
                            maxWidth: 100,
                          ), // Largeur maximale de l'image
                          child: Image.asset(
                            "assets/images/logo.png",
                            fit: BoxFit.cover, // Ajuste l'image à son conteneur
                          ),
                        ),
                      ],
                    ),
                    // Nova
                    Row(
                      children: [
                        Container(
                          width:
                              double
                                  .infinity, // Prend toute la largeur possible
                          constraints: BoxConstraints(
                            maxWidth: 40,
                          ), // Largeur maximale de l'image
                          child: Image.asset(
                            "assets/images/logo.png",
                            fit: BoxFit.cover, // Ajuste l'image à son conteneur
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            children: [
                              _buildNutrientTag("Matières grasses", Colors.red),
                              _buildNutrientTag("Sel", Colors.yellow),
                              _buildNutrientTag(
                                "Graisses saturées",
                                Colors.red,
                              ),
                              _buildNutrientTag("Sucres", Colors.red),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Quantité : 304 g",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(children: [Text("Code-barres : 8000500310427")]),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text.rich(
                              TextSpan(
                                text: "Plus d'informations : ",
                                children: [
                                  TextSpan(
                                    text: "...",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 64),
                Row(
                  children: [
                    Expanded(
                      child: const Text.rich(
                        TextSpan(
                          text:
                              "Notre fonctionnalité intelligente vous propose instantanément des alternatives ",
                          children: [
                            TextSpan(
                              text: "mieux notées et tout aussi savoureuses",
                              style: TextStyle(
                                backgroundColor: Color.fromRGBO(
                                  0,
                                  189,
                                  126,
                                  0.6,
                                ),
                              ),
                            ),
                            TextSpan(text: " :"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text.rich(
                          TextSpan(
                            text: "A",
                            style: TextStyle(
                              fontFamily: 'Grand Hotel',
                              fontSize: 32,
                              color: Colors.redAccent,
                            ),
                            children: [
                              TextSpan(
                                text: "lternatives",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Wrap(
                        children: [
                          SizedBox(width: (screenWidth / 100) * 1.5),
                          ProductCard(
                            imageUrl: 'assets/images/logo.png',
                            title: 'Gerblé',
                            description: 'Biscuits au édulcorants',
                            nutriscore: 'assets/images/logo.png',
                            novaGroup: 'assets/images/logo.png',
                          ),
                          SizedBox(width: (screenWidth / 100) * 1.5),
                          ProductCard(
                            imageUrl: 'assets/images/logo.png',
                            title: 'Gerblé',
                            description: 'Biscuits au édulcorants',
                            nutriscore: 'assets/images/logo.png',
                            novaGroup: 'assets/images/logo.png',
                          ),
                          SizedBox(width: (screenWidth / 100) * 1.5),
                          ProductCard(
                            imageUrl: 'assets/images/logo.png',
                            title: 'Gerblé',
                            description: 'Biscuits au édulcorants',
                            nutriscore: 'assets/images/logo.png',
                            novaGroup: 'assets/images/logo.png',
                          ),
                          SizedBox(width: (screenWidth / 100) * 1.5),
                          ProductCard(
                            imageUrl: 'assets/images/logo.png',
                            title: 'Gerblé',
                            description: 'Biscuits au édulcorants',
                            nutriscore: 'assets/images/logo.png',
                            novaGroup: 'assets/images/logo.png',
                          ),
                          SizedBox(width: (screenWidth / 100) * 1.5),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: const Text.rich(
                        TextSpan(
                          text: "Trouvez des options ",
                          children: [
                            TextSpan(
                              text: "plus saines",
                              style: TextStyle(
                                backgroundColor: Color.fromRGBO(
                                  0,
                                  189,
                                  126,
                                  0.6,
                                ),
                              ),
                            ),
                            TextSpan(
                              text:
                                  " et faites de chaque choix un pas vers une meilleure santé.",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 80),
            const Column(
              children: [
                Text('Titre de la section "dernières produits ajoutés"'),
              ],
            ),
            const SizedBox(height: 25),
            const Column(children: [Text('Liste des produits')]),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Widget _buildNutrientTag(String label, Color color) {
  return Container(
    margin: const EdgeInsets.only(right: 8, top: 16),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );
}
