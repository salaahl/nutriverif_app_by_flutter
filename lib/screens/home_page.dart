import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_nutriverif/providers/products_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../widgets/app_bar.dart';
import '../widgets/search_bar.dart';
import '../widgets/product_card.dart';

import '../models/model_products.dart';
import 'package:app_nutriverif/screens/product_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Set<String> _animatedProductIds = {};
  final YoutubePlayerController _youtubePlayerController =
      YoutubePlayerController(
        initialVideoId: 'D1jzT02IBRA',
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          isLive: false,
          forceHD: true,
        ),
      );

  late Product _productDemo = Product.fromJson({});
  late DateTime date = DateTime.now();
  late List<Products> _suggestedProductsDemo = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<ProductsProvider>(context, listen: false);

      // Attente des appels asynchrones
      await provider.fetchProduct('8000500310427');
      await provider.fetchLastProducts();

      if (!mounted) return; // ⛔️ stop si on a quitté la page

      setState(() {
        // Mise à jour de _productDemo après avoir récupéré les données
        _productDemo = provider.product;
        date = DateTime.fromMillisecondsSinceEpoch(
          int.parse(_productDemo.lastUpdate) * 1000,
        );
        _suggestedProductsDemo = provider.suggestedProducts;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductsProvider>();

    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            !_animatedProductIds.contains('firstSection')
                ? TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 250),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 100 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      myAppBar(context, route: '/'),
                      const SizedBox(height: 80),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Column(
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
                      ),
                      const SizedBox(height: 80),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Column(
                          children: [
                            AppSearchBar(provider: provider),
                            SizedBox(height: 32),
                            AnimatedSize(
                              duration: Duration(milliseconds: 350),
                              curve: Curves.easeInOut,
                              child: Column(
                                children: [
                                  Container(
                                    height:
                                        provider.productsIsLoading ||
                                                provider.products.isNotEmpty
                                            ? null
                                            : 0,
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        provider.productsIsLoading
                                            ? ProductPageState().loadingWidget()
                                            : Wrap(
                                              alignment:
                                                  WrapAlignment.spaceBetween,
                                              spacing:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width /
                                                  100 *
                                                  4,
                                              children:
                                                  provider.products.take(4).map(
                                                    (product) {
                                                      return ProductCard(
                                                        widthAjustment: 32,
                                                        id: product.id,
                                                        imageUrl: product.image,
                                                        title: product.brand,
                                                        description:
                                                            product.name,
                                                        nutriscore:
                                                            product.nutriscore,
                                                        nova: product.nova,
                                                      );
                                                    },
                                                  ).toList(),
                                            ),
                                      ],
                                    ),
                                  ),
                                  if (provider.products.length >
                                      3) // Si la liste contient 4 produits ou plus
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            backgroundColor:
                                                const Color.fromRGBO(
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
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 35),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Column(
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
                                      end:
                                          Alignment
                                              .centerLeft, // Fin du gradient à gauche
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
                      ),
                      const SizedBox(height: 80),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: YoutubePlayer(
                                      controller: _youtubePlayerController,
                                      bottomActions:
                                          [], // Hide the bottom actions
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_rounded, size: 18),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                )
                : SizedBox(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                ),
            VisibilityDetector(
              key: Key('scores'),
              onVisibilityChanged: (info) {
                if (info.visibleBounds.height > 50 &&
                    !_animatedProductIds.contains('scores')) {
                  setState(() {
                    _animatedProductIds.add('scores');
                  });
                }
              },
              child:
                  _animatedProductIds.contains('scores')
                      ? TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 250),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 100 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.displayLarge!,
                                      children: [
                                        TextSpan(text: 'Votre alimentation '),
                                        TextSpan(
                                          text: 'décryptée',
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                          ),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.network(
                                            'https://static.openfoodfacts.org/images/attributes/dist/nutriscore-a.svg',
                                            width: 160,
                                            semanticsLabel:
                                                'Image du Nutriscore',
                                          ),
                                          const SizedBox(height: 16),
                                          const Text(
                                            "Le Nutri-Score est un système d'étiquetage nutritionnel qui aide les consommateurs à identifier la qualité nutritionnelle des aliments. "
                                            "Il classe les produits de A (meilleure qualité nutritionnelle) à E (moins favorable), en prenant en compte des critères tels que les "
                                            "nutriments bénéfiques (fibres, protéines) et les éléments à limiter (sucre, sel). Ce score, accompagné de couleurs, permet de faire des choix alimentaires plus éclairés.",
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                            ),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.network(
                                            'https://static.openfoodfacts.org/images/attributes/dist/nova-group-1.svg',
                                            width: 40,
                                            semanticsLabel:
                                                'Image du Nova score',
                                          ),
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
                          ),
                        ),
                      )
                      : SizedBox(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                      ),
            ),
            const SizedBox(height: 80),
            VisibilityDetector(
              key: Key('productDemo'),
              onVisibilityChanged: (info) {
                if (info.visibleBounds.height > 50 &&
                    !_animatedProductIds.contains('productDemo')) {
                  setState(() {
                    _animatedProductIds.add('productDemo');
                  });
                }
              },
              child:
                  _animatedProductIds.contains('productDemo')
                      ? TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 250),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 100 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          decoration: BoxDecoration(color: Colors.grey[300]),
                          child: Column(
                            children: [
                              const SizedBox(height: 40),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        text: "Découvrez des ",
                                        children: [
                                          TextSpan(
                                            text: "alternatives",
                                            style: TextStyle(
                                              color: Color(0xFF00BD7E),
                                            ),
                                          ),
                                          TextSpan(text: " plus saines"),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.displayLarge!,
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
                                        style: TextStyle(
                                          backgroundColor: Color(0xFF00BD7E),
                                        ),
                                        children: [
                                          TextSpan(
                                            text:
                                                ". Si un produit a un Nutri-Score jugé trop faible :",
                                            style: TextStyle(
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              // Présentation partielle d'un produit
                              Column(
                                children: [
                                  if (provider.productIsLoading)
                                    ProductPageState().loadingWidget()
                                  else ...[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Image du produit
                                        AspectRatio(
                                          aspectRatio: 1,
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(32),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child:
                                                _productDemo.image.isEmpty
                                                    ? ProductPageState()
                                                        .loadingWidget()
                                                    : Image.network(
                                                      _productDemo.image,
                                                      width: 160,
                                                      semanticLabel:
                                                          'Image du produit',
                                                    ),
                                          ),
                                        ),
                                        const SizedBox(height: 32),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Nom et marque
                                            Text.rich(
                                              TextSpan(
                                                text:
                                                    "${_productDemo.brand} - ",
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF00BD7E),
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        _productDemo
                                                            .genericName,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "Dernière mise à jour : ${date.day}-${date.month}-${date.year}",
                                            ),
                                            const SizedBox(height: 16),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  constraints: BoxConstraints(
                                                    maxWidth: 100,
                                                  ),
                                                  child: SvgPicture.network(
                                                    "https://static.openfoodfacts.org/images/attributes/dist/nutriscore-${_productDemo.nutriscore}-new-fr.svg",
                                                    width: 100,
                                                    fit: BoxFit.cover,
                                                    semanticsLabel:
                                                        'Nutriscore ${_productDemo.nutriscore}',
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Container(
                                                  constraints: BoxConstraints(
                                                    maxWidth: 30,
                                                  ),
                                                  child: SvgPicture.network(
                                                    "https://static.openfoodfacts.org/images/attributes/dist/nova-group-${_productDemo.nova}.svg",
                                                    width: 30,
                                                    fit: BoxFit.cover,
                                                    semanticsLabel:
                                                        'NOVA ${_productDemo.nova}',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 32),
                                            Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              children:
                                                  _productDemo.nutrientLevels.entries.map((
                                                    entry,
                                                  ) {
                                                    Color bgColor;

                                                    switch (entry.value) {
                                                      case 'high':
                                                        bgColor = Colors.red;
                                                        break;
                                                      case 'moderate':
                                                        bgColor = Colors.orange;
                                                        break;
                                                      case 'low':
                                                        bgColor = Colors.green;
                                                        break;
                                                      default:
                                                        bgColor = Colors.grey;
                                                    }

                                                    return Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 6,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: bgColor,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              20,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        entry.key,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 64),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: const Text.rich(
                                            TextSpan(
                                              text:
                                                  "Notre fonctionnalité intelligente vous propose instantanément des alternatives ",
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "mieux notées et tout aussi savoureuses",
                                                  style: TextStyle(
                                                    backgroundColor:
                                                        Color.fromRGBO(
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
                                    const SizedBox(height: 32),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(
                                              999,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.arrow_downward_rounded,
                                            color: const Color(0xFF00BD7E),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 48),
                                    provider.suggestedProductsIsLoading
                                        ? ProductPageState().loadingWidget()
                                        : ProductPageState()
                                            .alternativeProducts(
                                              context,
                                              provider,
                                              _suggestedProductsDemo,
                                            ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 32),
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
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      )
                      : SizedBox(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                      ),
            ),
            const SizedBox(height: 80),
            VisibilityDetector(
              key: Key('lastProducts'),
              onVisibilityChanged: (info) {
                if (info.visibleBounds.height > 50 &&
                    !_animatedProductIds.contains('lastProducts')) {
                  setState(() {
                    _animatedProductIds.add('lastProducts');
                  });
                }
              },
              child:
                  _animatedProductIds.contains('lastProducts')
                      ? TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 250),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 100 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        text: "Produits",
                                        children: [
                                          TextSpan(
                                            text: " recemment ",
                                            style: TextStyle(
                                              color: Color(0xFF00BD7E),
                                            ),
                                          ),
                                          TextSpan(text: "ajoutés"),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.displayLarge!,
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
                                        ? ProductPageState().loadingWidget()
                                        : Wrap(
                                          alignment: WrapAlignment.spaceBetween,
                                          spacing:
                                              MediaQuery.of(
                                                context,
                                              ).size.width /
                                              100 *
                                              4,
                                          children:
                                              provider.lastProducts.map((
                                                product,
                                              ) {
                                                return ProductCard(
                                                  widthAjustment: 32,
                                                  id: product.id,
                                                  imageUrl: product.image,
                                                  title: product.brand,
                                                  description: product.name,
                                                  nutriscore:
                                                      product.nutriscore,
                                                  nova: product.nova,
                                                );
                                              }).toList(),
                                        ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : SizedBox(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                      ),
            ),
            VisibilityDetector(
              key: Key('lastSection'),
              onVisibilityChanged: (info) {
                if (info.visibleBounds.height > 0 &&
                    !_animatedProductIds.contains('lastSection')) {
                  setState(() {
                    _animatedProductIds.add('lastSection');
                  });
                }
              },
              child:
                  _animatedProductIds.contains('lastSection')
                      ? TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 250),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 50 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Column(
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
                      )
                      : SizedBox(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                      ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
