import 'package:devpedia/auth%20and%20cloud/auth_provider.dart';
import 'package:devpedia/screens/chat_screen.dart';
import 'package:devpedia/screens/feedback_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pod_player/pod_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late TabController _tabController;
  late final PodPlayerController controller;

  @override
  void initState() {
    super.initState();
    _loadSavedPosition();

    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.youtube(
        widget.resourceURL,
      ),
      podPlayerConfig: const PodPlayerConfig(autoPlay: false),
    )..initialise();

    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _loadSavedPosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedPosition = prefs.getInt('${widget.resourceURL}_position') ?? 0;

    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.youtube(
        widget.resourceURL,
      ),
      podPlayerConfig: const PodPlayerConfig(
        autoPlay: false,
      ),
    )..initialise();
  }

  Future<void> _savePosition() async {
    final position = controller.currentVideoPosition.inSeconds;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${widget.resourceURL}_position', position);
  }

  @override
  Widget build(BuildContext context) {
    final authRepositoryController = ref.watch(authRepositoryProvider);

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
                Builder(
                  builder: (context) {
                    return ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        PodVideoPlayer(controller: controller),
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
                          'Channel: ${widget.channelName}',
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Published Date: ${widget.publishedDate}",
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
                    );
                  },
                ),
                ChatScreen1(userEmail: authRepositoryController.userEmail!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _savePosition();
    controller.dispose();
    _tabController.dispose();
    super.dispose();
  }
}
