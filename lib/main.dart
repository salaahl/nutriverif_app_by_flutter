import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriVerif',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(toolbarHeight: 172),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'D1jzT02IBRA?si=gKqH8EWw5KYl42we', // ID de la vidéo YouTube
    flags: const YoutubePlayerFlags(
      autoPlay: false, // Ne démarre pas automatiquement
    ),
  );

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Column(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 80,
              width: 80,
              fit: BoxFit.contain,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Nutri',
                  style: TextStyle(
                    fontFamily: 'Grand Hotel',
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  'Vérif',
                  style: TextStyle(
                    fontFamily: 'Grand Hotel',
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    color: Color.fromRGBO(0, 189, 126, 1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: ListView(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            //
            // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
            // action in the IDE, or press "p" in the console), to see the
            // wireframe for each widget.
            children: [
              SizedBox(height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Nutri',
                    style: TextStyle(
                      fontFamily: 'Grand Hotel',
                      fontSize: 60,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
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
              Text(
                'Manger (plus) sain',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w100),
              ),
              SizedBox(height: 80),
              TextField(
                decoration: InputDecoration(
                  hintText:
                      'Entrez un nom de produit, un code-barres, une marque ou un type d\'aliment',
                  hintStyle: const TextStyle(
                    color: Colors.grey, // Texte gris pour le placeholder
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
              SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [
                          Color(0xFF5D576B80),
                          Color(0xFF2F2C36),
                        ], // Dégradé de couleurs
                        begin:
                            Alignment.centerRight, // Début du gradient à droite
                        end: Alignment.centerLeft, // Fin du gradient à gauche
                      ).createShader(bounds);
                    },
                    child: Text(
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
              SizedBox(height: 80),
              Wrap(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                    ),
                  ),
                  SizedBox(height: 32),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              'NutriVérif est alimentée par "Open Food Facts", une base de données de produits alimentaires créée par tous et pour tous. Vous pouvez l\'utiliser pour faire de meilleurs choix alimentaires, et comme les données sont ouvertes, tout le monde peut les réutiliser pour tout usage.',
                          style: TextStyle(
                            backgroundColor: Color.fromRGBO(
                              0,
                              189,
                              126,
                              1,
                            ), // Applique le surlignage seulement sur le texte
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      print('Next');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('En savoir plus'),
                        Icon(Icons.navigate_next_rounded),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Titre de la section "scores"')],
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Nutri Score')],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Nova Score')],
              ),
              SizedBox(height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Titre de la section "produit démo"')],
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Démo du produit')],
              ),
              SizedBox(height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Titre de la section "dernières produits ajoutés"'),
                ],
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Liste des produits')],
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
