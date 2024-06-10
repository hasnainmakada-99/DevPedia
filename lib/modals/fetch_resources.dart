// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:devpedia/modals/courses_modal.dart'; // Assuming your Course model is in course_modal.dart

// Future<List<Courses>> fetchCourses({String? filter}) async {
//   var dio = Dio();
//   SharedPreferences prefs = await SharedPreferences.getInstance();

//   try {
//     final response = await dio.get(
//       'http://192.168.0.106:3000/get-resources',
//     );

//     if (response.statusCode == 200) {
//       Iterable list = response.data;

//       prefs.setString('cachedCourses', jsonEncode(list));
//       prefs.setString(
//           'lastFetchTime', DateTime.now().toUtc().toIso8601String());

//       List<Courses> courses =
//           list.map((model) => Courses.fromJson(model)).toList();

//       if (filter != null && filter.isNotEmpty) {
//         courses = courses
//             .where((course) => course.toolRelatedTo == filter.toLowerCase())
//             .toList();
//       }

//       return courses;
//     } else if (response.statusCode == 304) {
//       return loadCachedCourses();
//     } else {
//       throw Exception('Failed to load courses');
//     }
//   } catch (error) {
//     print('Error fetching data: $error');
//     return loadCachedCourses();
//   }
// }

// Future<List<Courses>> loadCachedCourses() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? cachedCourses = prefs.getString('cachedCourses');

//   if (cachedCourses != null) {
//     Iterable list = jsonDecode(cachedCourses);
//     return list.map((model) => Courses.fromJson(model)).toList();
//   } else {
//     return [];
//   }
// }

// Future<String> getInstructorIdForCourse(String courseId) async {
//   return "placeholder_instructor_id";
// }

import 'dart:convert';

import 'package:devpedia/modals/courses_modal.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Courses>> fetchCourses({String? filter}) async {
  var dio = Dio();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    final response = await dio.get(
      'https://devpedia-uqxf.onrender.com/api/get-resources',
    );

    if (response.statusCode == 200) {
      List<dynamic> data = response.data; // Changed to List<dynamic>

      prefs.setString('cachedCourses', jsonEncode(data));
      prefs.setString(
          'lastFetchTime', DateTime.now().toUtc().toIso8601String());

      List<Courses> courses =
          data.map((model) => Courses.fromJson(model)).toList();

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
