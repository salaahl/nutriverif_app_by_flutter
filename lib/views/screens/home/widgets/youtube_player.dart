import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

class LazyYoutubePlayer extends StatefulWidget {
  const LazyYoutubePlayer({super.key});

  @override
  State<LazyYoutubePlayer> createState() => _LazyYoutubePlayerState();
}

class _LazyYoutubePlayerState extends State<LazyYoutubePlayer>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late YoutubePlayerController _controller;
  static bool? _cachedCookiesStatus;
  late bool _showPlayer =
      false; // Variable pour stocker l'acceptation des cookies

  final String videoId = 'D1jzT02IBRA';

  // Charger la valeur stockée
  Future<void> _getCookiesStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final status = prefs.getBool('acceptCookies') ?? false;

      setState(() {
        _showPlayer = status;
        _cachedCookiesStatus = status;
      });
    } catch (e) {
      setState(() {
        _showPlayer = false;
        _cachedCookiesStatus = false;
      });
    }
  }

  // Sauvegarder la valeur
  Future<void> _setCookiesStatus(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('acceptCookies', value);
      setState(() {
        _showPlayer = value;
      });
    } catch (e) {
      setState(() {
        _showPlayer = true;
      });
    }
  }

  Future<bool?> acceptCookies(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Text(
                "Cookies",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationThickness: 4,
                  decorationColor: Colors.black, // couleur noire
                ),
              ),
            ],
          ),
          content: Text(
            'Cette vidéo est hébergée par YouTube. Son affichage sur ce site implique le dépôt de cookies par YouTube (Google).\n\nCes cookies sont uniquement liés à la lecture de la vidéo et n’ont pas d’effet sur vos autres services Google.\n\nVoulez-vous les accepter et afficher la vidéo ?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Annuler"),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: customGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
                _setCookiesStatus(true);
              },
              child: const Text(
                "Accepter",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: false,
      ),
    );

    _showPlayer = _cachedCookiesStatus ?? false;

    if (_cachedCookiesStatus == null) {
      _getCookiesStatus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Permet de retourner un cacheWidth adapté à la résolution de l'écran
    int getCacheWidth(BuildContext context, double logicalWidth) {
      final ratio = MediaQuery.of(context).devicePixelRatio;
      return (logicalWidth * ratio).round();
    }

    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(12),
      child:
          _showPlayer
              ? RepaintBoundary(
                child: YoutubePlayer(
                  controller: _controller,
                  bottomActions: [],
                ),
              )
              : GestureDetector(
                onTap: () async => await acceptCookies(context),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Pour récupérer l'image de la vidéo depuis le net : YoutubePlayer.getThumbnail(videoId: videoId)
                      Image.asset(
                        "assets/images/home-video-thumb.jpg",
                        cacheWidth: getCacheWidth(
                          context,
                          MediaQuery.of(context).size.width -
                              32, // Correspon au padding de la page
                        ),
                        fit: BoxFit.cover,
                      ),
                      const Icon(
                        Icons.play_arrow_rounded,
                        size: 64,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
