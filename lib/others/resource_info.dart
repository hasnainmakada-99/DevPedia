import 'package:devpedia/auth/auth_provider.dart';
import 'package:devpedia/chat/chat_screen.dart';
import 'package:devpedia/others/feedback_screen.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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

class _ResourceInfoState extends ConsumerState<ResourceInfo>
    with SingleTickerProviderStateMixin {
  late YoutubePlayerController _controller;
  var ratingText = '';
  late TabController _tabController; // Delare the TabController

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.resourceURL) ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        showLiveFullscreenButton: true,
      ),
    );
    _tabController =
        TabController(length: 2, vsync: this); // Initialize the TabController
  }

  @override
  Widget build(BuildContext context) {
    final authRepositoryController = ref.watch(authRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.resourceTitle),
        automaticallyImplyLeading: !_controller.value.isFullScreen,
      ),
      body: Column(
        children: [
          TabBar(
            // Add the TabBar widget
            controller: _tabController, // Assign the TabController
            tabs: const [
              Tab(text: 'Video'), // Add a tab for the video
              Tab(text: 'DevAi'), // Add a tab for the chat
            ],
          ),
          Expanded(
            child: TabBarView(
              // Add the TabBarView widget
              controller: _tabController, // Assign the TabController
              children: [
                YoutubePlayerBuilder(
                  player: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.blueAccent,
                    progressColors: const ProgressBarColors(
                      playedColor: Colors.blue,
                      handleColor: Colors.blueAccent,
                    ),
                  ),
                  builder: (context, player) {
                    return Column(
                      children: [
                        player,
                        // Add video description here
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                widget.resourceDescription,
                                style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 2,
                        ),

                        Text('Channel: ${widget.channelName}'),
                        const SizedBox(
                          height: 2,
                        ),

                        Text("Published Date: ${widget.publishedDate}"),
                        const SizedBox(
                          height: 2,
                        ),

                        const SizedBox(
                          height: 2,
                        ),

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
                ChatScreen(userEmail: authRepositoryController.userEmail),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose(); // Dispose the TabController
    super.dispose();
  }
}
