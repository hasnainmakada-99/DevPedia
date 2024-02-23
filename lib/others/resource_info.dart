import 'package:devpedia/others/feedback_screen.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ResourceInfo extends ConsumerStatefulWidget {
  final String resourceTitle;
  final String resourceURL;
  final String resourceDescription;
  final String channelName;
  final String publishedDate;
  final String resourceRelatedTo;
  const ResourceInfo({
    Key? key,
    required this.resourceURL,
    required this.resourceDescription,
    required this.resourceTitle,
    required this.channelName,
    required this.publishedDate,
    required this.resourceRelatedTo,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResourceInfoState();
}

class _ResourceInfoState extends ConsumerState<ResourceInfo> {
  late YoutubePlayerController _controller;
  var ratingText = '';
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.resourceURL)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        showLiveFullscreenButton: true,
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
        title: Text(widget.resourceTitle),
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
                    Expanded(
                      child: Text(
                        widget.resourceDescription,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Text(widget.channelName),
                    const SizedBox(
                      height: 10,
                    ),

                    Text(widget.publishedDate),
                    const SizedBox(
                      height: 10,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    // Add 1 button over here which will redirect to the feedback screen.
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FeedbackScreen(
                              resourceRelatedTo: widget.resourceRelatedTo,
                            ),
                          ),
                          (route) => true,
                        );
                      },
                      child: const Text('Give Feedback on this Resource'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
