import 'dart:convert';

// import 'package:devpedia/modals/resource_modal.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Future<List<ResourceModal>> fetchVideos() async {
//   var dio = Dio();
//   SharedPreferences prefs = await SharedPreferences.getInstance();

//   // Retrieve the last fetch time from cache
//   final lastFetchTime = prefs.getString('lastFetchTime');

//   // Add a custom header for conditional requests
//   var headers = {
//     'If-Modified-Since': lastFetchTime ?? '',
//   };

//   try {
//     final response = await dio.get(
//       'http://devpedia-uqxf.onrender.com/api/get-resources',
//       options: Options(headers: headers),
//     );

//     if (response.statusCode == 200) {
//       // If the server returns a 200 OK response, parse the JSON.
//       Iterable list = response.data;

//       // Save the data to the cache
//       prefs.setString('cachedVideos', jsonEncode(list));
//       prefs.setString(
//           'lastFetchTime', DateTime.now().toUtc().toIso8601String());

//       return list.map((model) => ResourceModal.fromJson(model)).toList();
//     } else if (response.statusCode == 304) {
//       // If the server returns a 304 Not Modified response, return cached data
//       return loadCachedVideos();
//     } else {
//       throw Exception('Failed to load videos');
//     }
//   } catch (error) {
//     // On any error, return cached data if available
//     print('Error fetching data: $error');
//     return loadCachedVideos();
//   }
// }

// Future<List<ResourceModal>> loadCachedVideos() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? cachedVideos = prefs.getString('cachedVideos');

//   if (cachedVideos != null) {
//     Iterable list = jsonDecode(cachedVideos);
//     return list.map((model) => ResourceModal.fromJson(model)).toList();
//   } else {
//     return [];
//   }
// }

import 'package:devpedia/modals/course_modal.dart'; // Assuming your Course model is in course_modal.dart

Future<List<Courses>> fetchCourses() async {
  var dio = Dio();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Retrieve the last fetch time from cache

  // Add a custom header for conditional requests

  try {
    final response = await dio.get(
      'http://devpedia-uqxf.onrender.com/api/get-resources', // Assuming the endpoint provides courses
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      Iterable list = response.data;

      // Save the data to the cache
      prefs.setString('cachedCourses', jsonEncode(list));
      prefs.setString(
          'lastFetchTime', DateTime.now().toUtc().toIso8601String());

      return list.map((model) => Courses.fromJson(model)).toList();
    } else if (response.statusCode == 304) {
      // If the server returns a 304 Not Modified response, return cached data
      return loadCachedCourses();
    } else {
      throw Exception('Failed to load courses');
    }
  } catch (error) {
    // On any error, return cached data if available
    print('Error fetching data: $error');
    return loadCachedCourses();
  }
}

Future<List<Courses>> loadCachedCourses() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? cachedCourses = prefs.getString('cachedCourses');

  if (cachedCourses != null) {
    Iterable list = jsonDecode(cachedCourses);
    return list.map((model) => Courses.fromJson(model)).toList();
  } else {
    return [];
  }
}

// This function retrieves the instructor ID for a given course (if needed)
Future<String> getInstructorIdForCourse(String courseId) async {
  // Implement your logic to retrieve instructor ID based on courseId from Firebase or another source
  // This could involve a Firestore query or an API call
  // Replace with your actual implementation
  return "placeholder_instructor_id"; // Replace with actual logic
}
