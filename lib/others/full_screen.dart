import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FullScreen extends StatefulWidget {
  final YoutubePlayerController controller;
  const FullScreen({Key? key, required this.controller}) : super(key: key);

  @override
  _FullScreenState createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen>
    with SingleTickerProviderStateMixin {
  // late YoutubePlayerController _controller;
  var ratingText = '';
  late TabController _tabController; // Declare the TabController

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          if (orientation == Orientation.landscape) {
            return Scaffold(
              body: youtubeHierarchy(),
            );
          } else {
            return Scaffold(
              body: youtubeHierarchy(),
            );
          }
        },
      ),
    );
  }

  Widget youtubeHierarchy() {
    return Align(
      child: FittedBox(
        fit: BoxFit.cover,
        child: YoutubePlayer(
          controller: widget.controller,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // _controller.dispose();
    _tabController.dispose(); // Dispose the TabController
    super.dispose();
  }
}
