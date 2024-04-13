import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FullscreenVideo extends StatelessWidget {
  final YoutubePlayerController controller;

  const FullscreenVideo({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.blueAccent,
                progressColors: const ProgressBarColors(
                  playedColor: Colors.blue,
                  handleColor: Colors.blueAccent,
                ),
              ),
              builder: (context, player) {
                return Stack(
                  children: [
                    player,
                    IconButton(
                      icon: const Icon(Icons.fullscreen_exit),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
