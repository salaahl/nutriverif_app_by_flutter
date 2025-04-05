import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async'; // Importe la bibliothèque pour les timers
import 'package:app_nutriverif/providers/products_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../widgets/my_app_bar.dart';
import '../widgets/product_card.dart';
import '../models/model_products.dart';

import 'package:app_nutriverif/screens/product_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'D1jzT02IBRA?si=gKqH8EWw5KYl42we', // ID de la vidéo YouTube
    flags: const YoutubePlayerFlags(autoPlay: false),
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProductsProvider>(context, listen: false);

      provider.fetchProduct('8000500310427');
      provider.fetchLastProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Variables relatives aux produits
    final provider = context.watch<ProductsProvider>();

    /* Vérifier si les produits sont déjà chargés, sinon appeler les méthodes pour les charger
    if (!productIsLoading && provider.product.id.isEmpty) {
      provider.fetchProduct('8000500310427');
    }

    if (!lastProductsIsLoading && provider.lastProducts.isEmpty) {
      provider.fetchLastProducts();
    }
    */

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
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText:
                              'Entrez un nom de produit, un code-barres...',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
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
                              color: Color(0xFF9CA3AF),
                              width: 4.0,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 12.0,
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue[800],
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: const Icon(Icons.search, color: Colors.white),
                      ),
                      onPressed: () => provider.searchProducts(userInput: _searchController.text, method: 'complete'),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                provider.products.isEmpty && !provider.productsIsLoading
                    ? SizedBox.shrink() // Si aucun produit et pas de chargement, on n'affiche rien
                    : Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              provider.productsIsLoading
                                  ? ProductPage().loadingWidget()
                                  : Wrap(
                                    alignment: WrapAlignment.spaceBetween,
                                    spacing:
                                        MediaQuery.of(context).size.width /
                                        100 *
                                        4,
                                    children:
                                        provider.products.map((product) {
                                          return ProductCard(
                                            widthAjustment: 32,
                                            imageUrl: product.image,
                                            title: product.brand,
                                            description: product.name,
                                            nutriscore:
                                                "assets/images/logo.png",
                                            nova: "assets/images/logo.png",
                                          );
                                        }).toList(),
                                  ),
                            ],
                          ),
                        ),
                        if (provider.products.length ==
                            4) // Si la liste contient 4 produits
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/products',
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor: const Color.fromRGBO(
                                    0,
                                    189,
                                    126,
                                    1,
                                  ), // Couleur du bouton
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
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
                      child: Text(
                        'En savoir plus',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
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
                const SizedBox(height: 32),
                // Page produit
                Column(
                  children: [
                    // Section Produit Principal
                    if (provider.productIsLoading)
                      ProductPage().loadingWidget()
                    else ...[
                      ProductPage().productDetails(context, provider.product),
                      const SizedBox(height: 32),
                    ],

                    // Section Alternatives
                    ProductPage().alternativeProducts(
                      context,
                      provider,
                      ProductPage().loadingWidget(),
                      provider.suggestedProducts,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_upward_rounded,
                      color: const Color(0xFF00BD7E),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
                            TextSpan(text: "."),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: const Text.rich(
                    TextSpan(
                      text: "Produits",
                      children: [
                        TextSpan(
                          text: " recemment ",
                          style: TextStyle(color: Color(0xFF00BD7E)),
                        ),
                        TextSpan(text: "ajoutés"),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  provider.lastProductsIsLoading
                      ? ProductPage().loadingWidget()
                      : Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        spacing: MediaQuery.of(context).size.width / 100 * 4,
                        children:
                            provider.lastProducts.map((product) {
                              return ProductCard(
                                widthAjustment: 32,
                                imageUrl: product.image,
                                title: product.brand,
                                description: product.name,
                                nutriscore: "assets/images/logo.png",
                                nova: "assets/images/logo.png",
                              );
                            }).toList(),
                      ),
                ],
              ),
            ),
            Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(64),
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 160,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
