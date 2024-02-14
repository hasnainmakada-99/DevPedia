import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ResourceInfo extends ConsumerStatefulWidget {
  final String resourceURL;
  const ResourceInfo({Key? key, required this.resourceURL}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResourceInfoState();
}

class _ResourceInfoState extends ConsumerState<ResourceInfo> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.resourceURL)!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing 1'),
        automaticallyImplyLeading: !_controller.value.isFullScreen,
      ),
      body: Column(
        children: [
          Expanded(
            child: YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.blueAccent,
                progressColors: const ProgressBarColors(
                  playedColor: Colors.blue,
                  handleColor: Colors.blueAccent,
                ),
                onReady: () {
                  // Perform any additional setup after player is ready
                },
              ),
              builder: (context, player) {
                return Column(
                  children: [
                    player,
                    // Add video description here
                    const Text('Video Description'),
                  ],
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _controller.toggleFullScreenMode();
            },
            child: const Text('Enter Full Screen'),
          ),
        ],
      ),
    );
  }
}
