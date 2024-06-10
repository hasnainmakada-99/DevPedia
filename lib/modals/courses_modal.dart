// import 'package:cloud_firestore/cloud_firestore.dart';

// class Courses {
//   final String courseId;
//   final String title;
//   final String description;
//   // final String instructorId;
//   final int price;
//   final String thumbnail;
//   final String url;
//   final DateTime publishedDate;
//   final String channelName;
//   final String toolRelatedTo;

//   Courses({
//     required this.courseId,
//     required this.title,
//     required this.description,
//     // required this.instructorId,
//     required this.price,
//     required this.thumbnail,
//     required this.url,
//     required this.publishedDate,
//     required this.channelName,
//     required this.toolRelatedTo,
//   });

//   factory Courses.fromJson(Map<String, dynamic> json) => Courses(
//         courseId: json['_id'] as String,
//         title: json['title'] as String,
//         description: json['description'] as String,
//         // instructorId: json['instructorId'] as String,
//         price: json['price'] as int,
//         thumbnail: json['thumbnail'] as String,
//         url: json['url'] as String,
//         publishedDate: json['publishedDate'],
//         channelName: json['channelName'] as String,
//         toolRelatedTo: json['toolRelatedTo'] as String,
//       );

//   Map<String, dynamic> toJson() => {
//         'courseId': courseId,
//         'title': title,
//         'description': description,
//         // 'instructorId': instructorId,
//         'price': price,
//         'thumbnail': thumbnail,
//         'url': url,
//         'publishedDate': DateTime,
//         'channelName': channelName,
//         'toolRelatedTo': toolRelatedTo,
//       };
// }

class Courses {
  final String id;
  final String title;
  final String url;
  final String description;
  final String thumbnail;
  final DateTime publishedDate;
  final String channelName;
  final String toolRelatedTo;
  final int price;
  final int v;

  Courses({
    required this.id,
    required this.title,
    required this.url,
    required this.description,
    required this.thumbnail,
    required this.publishedDate,
    required this.channelName,
    required this.toolRelatedTo,
    required this.price,
    required this.v,
  });

  factory Courses.fromJson(Map<String, dynamic> json) {
    return Courses(
      id: json['_id'],
      title: json['title'],
      url: json['url'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      publishedDate: DateTime.parse(json['publishedDate']),
      channelName: json['channelName'],
      toolRelatedTo: json['toolRelatedTo'],
      price: int.parse(json['price']),
      v: json['__v'],
    );
  }
}
