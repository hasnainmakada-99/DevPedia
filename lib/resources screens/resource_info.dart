import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:devpedia/auth%20and%20cloud/auth_provider.dart';
import 'package:devpedia/screens/chat_screen.dart';
import 'package:devpedia/screens/feedback_screen.dart';

class ResourceInfo extends ConsumerStatefulWidget {
  final String resourceTitle;
  final String resourceURL;
  final String resourceDescription;
  final String channelName;
  final DateTime publishedDate;
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
  late TabController _tabController;
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();

    // Initialize YouTubePlayerController
    _youtubeController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.resourceURL) ??
          'default_video_id', // Provide a fallback video ID
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        forceHD: true,
        controlsVisibleAtStart: true,
      ),
    );
    _tabController = TabController(length: 2, vsync: this);
  }

  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    final authRepositoryController = ref.watch(authRepositoryProvider);

    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _youtubeController,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.resourceTitle),
          ),
          body: Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Video'),
                  Tab(text: "Chat"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        // Display the YouTube Player
                        player,
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            widget.resourceDescription,
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Publisher: ${widget.channelName}',
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Published Date: ${formatter.format(widget.publishedDate)}",
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FeedbackScreen(
                                  resourceRelatedTo: widget.resourceRelatedTo,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            textStyle: const TextStyle(fontSize: 16),
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text(
                            'Give Feedback on this Resource',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    ChatScreen1(userEmail: authRepositoryController.userEmail!),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}
