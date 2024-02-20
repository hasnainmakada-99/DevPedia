import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ResourceInfo extends ConsumerStatefulWidget {
  final String resourceTitle;
  final String resourceURL;
  final String resourceDescription;
  const ResourceInfo({
    Key? key,
    required this.resourceURL,
    required this.resourceDescription,
    required this.resourceTitle,
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
                    Text(
                      widget.resourceDescription,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Text("Channel Name: FreecodeCamp"),
                    SizedBox(
                      height: 10,
                    ),

                    Text("Published Date: 12-20-3022"),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Please rate the resource"),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          ratingText = rating.toString();
                        });
                      },
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Text('data: $ratingText')
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