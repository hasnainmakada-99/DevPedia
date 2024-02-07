import 'package:devpedia/modals/resource_modal.dart';
import 'package:dio/dio.dart';
// import 'path_to_your_model/youtube_video.dart';

Future<List<ResourceModal>> fetchVideos() async {
  var dio = Dio();
  final response = await dio.get('http://192.168.79.80:3000/api/get-resources');

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON.
    Iterable list = response.data;
    return list.map((model) => ResourceModal.fromJson(model)).toList();
  } else {
    // If the server returns an unsuccessful response code, throw an exception.
    throw Exception('Failed to load videos');
  }
}
