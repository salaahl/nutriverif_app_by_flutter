import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LazyYoutubePlayer extends StatefulWidget {
  const LazyYoutubePlayer({super.key});

  @override
  State<LazyYoutubePlayer> createState() => _LazyYoutubePlayerState();
}

class _LazyYoutubePlayerState extends State<LazyYoutubePlayer> {
  final String videoId = 'D1jzT02IBRA';
  bool _showPlayer = false;

  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(12),
        child:
            _showPlayer
                ? YoutubePlayer(
                  controller: _controller,
                  bottomActions: [],
                )
                : GestureDetector(
                  onTap: () => setState(() => _showPlayer = true),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          YoutubePlayer.getThumbnail(videoId: videoId),
                          fit: BoxFit.cover,
                        ),
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
