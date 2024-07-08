// import 'package:flutter/material.dart';
// import 'package:devpedia/Testing%20Designs/YtModal.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class YouTubePlaylistScreen extends StatefulWidget {
//   @override
//   _YouTubePlaylistScreenState createState() => _YouTubePlaylistScreenState();
// }

// class _YouTubePlaylistScreenState extends State<YouTubePlaylistScreen> {
//   late YoutubePlayerController _controller;
//   late Future<List<YouTubeVideo>> _playlistItems;

//   final String apiKey = 'AIzaSyC40Ne_1nSYzHr4AmeIrwDPkeCwkQ8gMjU';
//   final String playlistId = 'PL4cUxeGkcC9g8OhpOZxNdhXggFz2lOuCT';

//   @override
//   void initState() {
//     super.initState();
//     _playlistItems = fetchPlaylistItems(apiKey, playlistId);
//     _controller = YoutubePlayerController(
//       initialVideoId: '', // Set an initial empty video ID or default video ID
//       flags: YoutubePlayerFlags(autoPlay: false),
//     );
//   }

//   void _playVideo(String videoId) {
//     _controller.load(videoId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('YouTube Playlist'),
//       ),
//       body: FutureBuilder<List<YouTubeVideo>>(
//         future: _playlistItems,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             return Column(
//               children: [
//                 YoutubePlayer(
//                   controller: _controller,
//                   showVideoProgressIndicator: true,
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: snapshot.data!.length,
//                     itemBuilder: (context, index) {
//                       final video = snapshot.data![index];
//                       return ListTile(
//                         leading: Image.network(video.thumbnailUrl),
//                         title: Text(video.title),
//                         onTap: () => _playVideo(video.videoId),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';
import 'YtModal.dart';

class YouTubePlaylistScreen extends StatefulWidget {
  @override
  _YouTubePlaylistScreenState createState() => _YouTubePlaylistScreenState();
}

class _YouTubePlaylistScreenState extends State<YouTubePlaylistScreen> {
  late PodPlayerController _controller;
  late Future<List<YouTubeVideo>> _playlistItems;
  YouTubeVideo? _selectedVideo;

  final String apiKey =
      'AIzaSyC40Ne_1nSYzHr4AmeIrwDPkeCwkQ8gMjU'; // Replace with your API key
  final String playlistId =
      'PL4cUxeGkcC9g8OhpOZxNdhXggFz2lOuCT'; // Replace with your Playlist ID

  @override
  void initState() {
    super.initState();
    _playlistItems = fetchPlaylistItems(apiKey, playlistId);
    _controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.youtube(''),
    )..initialise();
  }

  void _playVideo(YouTubeVideo video) {
    setState(() {
      _selectedVideo = video;
      _controller.changeVideo(
          playVideoFrom: PlayVideoFrom.youtube(video.videoId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Playlist'),
      ),
      body: FutureBuilder<List<YouTubeVideo>>(
        future: _playlistItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final videos = snapshot.data!;
            return Column(
              children: [
                if (_selectedVideo != null)
                  PodVideoPlayer(controller: _controller),
                Expanded(
                  child: ListView.builder(
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      final video = videos[index];
                      return ListTile(
                        leading: Image.network(video.thumbnailUrl),
                        title: Text(video.title),
                        onTap: () => _playVideo(video),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
