import 'dart:convert';

import 'package:devpedia/modals/resource_modal.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<ResourceModal>> fetchVideos() async {
  var dio = Dio();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Retrieve the last fetch time from cache
  final lastFetchTime = prefs.getString('lastFetchTime');

  // Add a custom header for conditional requests
  var headers = {
    'If-Modified-Since': lastFetchTime ?? '',
  };

  try {
    final response = await dio.get(
      'http://devpedia-uqxf.onrender.com/api/get-resources',
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      Iterable list = response.data;

      // Save the data to the cache
      prefs.setString('cachedVideos', jsonEncode(list));
      prefs.setString(
          'lastFetchTime', DateTime.now().toUtc().toIso8601String());

      return list.map((model) => ResourceModal.fromJson(model)).toList();
    } else if (response.statusCode == 304) {
      // If the server returns a 304 Not Modified response, return cached data
      return loadCachedVideos();
    } else {
      throw Exception('Failed to load videos');
    }
  } catch (error) {
    // On any error, return cached data if available
    print('Error fetching data: $error');
    return loadCachedVideos();
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
