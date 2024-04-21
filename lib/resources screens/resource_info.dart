import 'package:devpedia/auth/auth_provider.dart';
import 'package:devpedia/chat/test_chat.dart';
import 'package:devpedia/others/feedback_screen.dart';
import 'package:devpedia/others/full_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pod_player/pod_player.dart';
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
  var ratingText = '';
  late TabController _tabController; // Delare the TabController
  int _currentIndex = 0;
  late final PodPlayerController controller;
  @override
  void initState() {
    super.initState();
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.youtube(
        widget.resourceURL ?? '',
      ),
      podPlayerConfig: const PodPlayerConfig(autoPlay: false),
    )..initialise();
    // Initialize the TabController
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
          PodVideoPlayer(controller: controller),
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
          Text('Channel: ${widget.channelName}'),
          Text("Published Date: ${widget.publishedDate}"),
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(
            () {
              _currentIndex = index;
            },
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Video',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'DevAI',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    _tabController.dispose(); // Dispose the TabController
    super.dispose();
  }
}

// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class ResourceInfo extends StatefulWidget {
//   const ResourceInfo({Key? key}) : super(key: key);

//   @override
//   _ResourceInfoState createState() => _ResourceInfoState();
// }

// class _ResourceInfoState extends State<ResourceInfo>
//     with SingleTickerProviderStateMixin {
//   late YoutubePlayerController _controller;
//   var ratingText = '';
//   late TabController _tabController; // Declare the TabController

//   @override
//   void initState() {
//     super.initState();
//     _controller = YoutubePlayerController(
//       initialVideoId: YoutubePlayer.convertUrlToId(
//               'https://youtu.be/kdL7gagm4o0?si=Q_CJThgXy6-M1E5H') ??
//           '',
//       flags: const YoutubePlayerFlags(
//         autoPlay: false,
//         mute: false,
//         showLiveFullscreenButton: true,
//       ),
//     );
//     _tabController =
//         TabController(length: 2, vsync: this); // Initialize the TabController
//   }

  

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       // onWillPop: _onWillPop,
//       canPop: true,
//       child: OrientationBuilder(
        // builder: (BuildContext context, Orientation orientation) {
        //   if (orientation == Orientation.landscape) {
        //     return Scaffold(
        //       body: youtubeHierarchy(),
        //     );
        //   } else {
        //     return Scaffold(
        //       appBar: AppBar(
        //         title: Text('Title'),
        //       ),
        //       body: youtubeHierarchy(),
        //     );
        //   }
        // },
//       ),
//     );
//   }

//   Widget youtubeHierarchy() {
//     return Container(
//       child: Align(
//         alignment: Alignment.center,
//         child: FittedBox(
//           fit: BoxFit.cover,
//           child: YoutubePlayer(
//             controller: _controller,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _tabController.dispose(); // Dispose the TabController
//     super.dispose();
//   }
// }
