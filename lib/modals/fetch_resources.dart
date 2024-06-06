import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:devpedia/modals/course_modal.dart'; // Assuming your Course model is in course_modal.dart

// Future<List<Courses>> fetchCourses() async {
//   var dio = Dio();
//   SharedPreferences prefs = await SharedPreferences.getInstance();

//   try {
//     final response = await dio.get(
//       'http://devpedia-uqxf.onrender.com/api/get-resources', // Assuming the endpoint provides courses
//     );

//     if (response.statusCode == 200) {
//       Iterable list = response.data;

//       prefs.setString('cachedCourses', jsonEncode(list));
//       prefs.setString(
//           'lastFetchTime', DateTime.now().toUtc().toIso8601String());

//       return list.map((model) => Courses.fromJson(model)).toList();
//     } else if (response.statusCode == 304) {
//       // If the server returns a 304 Not Modified response, return cached data
//       return loadCachedCourses();
//     } else {
//       throw Exception('Failed to load courses');
//     }
//   } catch (error) {
//     // On any error, return cached data if available
//     print('Error fetching data: $error');
//     return loadCachedCourses();
//   }
// }

Future<List<Courses>> fetchCourses({String? filter}) async {
  var dio = Dio();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    final response = await dio.get(
      'http://devpedia-uqxf.onrender.com/api/get-resources',
    );

    if (response.statusCode == 200) {
      Iterable list = response.data;

      prefs.setString('cachedCourses', jsonEncode(list));
      prefs.setString(
          'lastFetchTime', DateTime.now().toUtc().toIso8601String());

      List<Courses> courses =
          list.map((model) => Courses.fromJson(model)).toList();

      if (filter != null && filter.isNotEmpty) {
        courses = courses
            .where((course) => course.toolRelatedTo == filter.toLowerCase())
            .toList();
      }

      return courses;
    } else if (response.statusCode == 304) {
      return loadCachedCourses();
    } else {
      throw Exception('Failed to load courses');
    }
  } catch (error) {
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

Future<String> getInstructorIdForCourse(String courseId) async {
  return "placeholder_instructor_id";
}
