import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<YouTubeVideo>> fetchPlaylistItems(
  String apiKey,
  String playlistId,
) async {
  final response = await http.get(Uri.parse(
      'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=20&playlistId=$playlistId&key=$apiKey'));

  if (response.statusCode == 200) {
    final List videos = json.decode(response.body)['items'];
    return videos.map((video) => YouTubeVideo.fromJson(video)).toList();
  } else {
    throw Exception('Failed to load playlist');
  }
}

class YouTubeVideo {
  final String videoId;
  final String title;
  final String thumbnailUrl;

  YouTubeVideo(
      {required this.videoId, required this.title, required this.thumbnailUrl});

  factory YouTubeVideo.fromJson(Map<String, dynamic> json) {
    return YouTubeVideo(
      videoId: json['snippet']['resourceId']['videoId'],
      title: json['snippet']['title'],
      thumbnailUrl: json['snippet']['thumbnails']['high']['url'],
    );
  }
}
