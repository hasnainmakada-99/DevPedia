import 'package:devpedia/modals/resource_modal.dart';
import 'package:dio/dio.dart';
// import 'path_to_your_model/youtube_video.dart';

Stream<List<ResourceModal>> fetchVideos() async* {
  var dio = Dio();
  final response =
      await dio.get('http://devpedia-uqxf.onrender.com/api/get-resources');

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON.
    Iterable list = response.data;
    yield list.map((model) => ResourceModal.fromJson(model)).toList();
  } else {
    // If the server returns an unsuccessful response code, throw an exception.
    throw Exception('Failed to load videos');
  }
}
