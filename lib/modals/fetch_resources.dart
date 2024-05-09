import 'dart:convert';

import 'package:devpedia/modals/resource_modal.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<ResourceModal>> fetchVideos() async {
  var dio = Dio();
  final response =
      await dio.get('http://devpedia-uqxf.onrender.com/api/get-resources');

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON.
    Iterable list = response.data;

    // Save the data to the cache
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cachedVideos', jsonEncode(list));

    return list.map((model) => ResourceModal.fromJson(model)).toList();
  } else {
    // If the server returns an unsuccessful response code, throw an exception.
    throw Exception('Failed to load videos');
  }
}

Future<List<ResourceModal>> loadCachedVideos() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? cachedVideos = prefs.getString('cachedVideos');

  if (cachedVideos != null) {
    Iterable list = jsonDecode(cachedVideos);
    return list.map((model) => ResourceModal.fromJson(model)).toList();
  } else {
    return [];
  }
}
