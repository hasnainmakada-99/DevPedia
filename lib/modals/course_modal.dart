import 'package:cloud_firestore/cloud_firestore.dart';

class Courses {
  final String courseId;
  final String title;
  final String description;
  // final String instructorId;
  // final double price;
  final String thumbnail;
  final String url;
  final String publishedDate;
  final String channelName;
  final String toolRelatedTo;

  Courses({
    required this.courseId,
    required this.title,
    required this.description,
    // required this.instructorId,
    // required this.price,
    required this.thumbnail,
    required this.url,
    required this.publishedDate,
    required this.channelName,
    required this.toolRelatedTo,
  });

  factory Courses.fromJson(Map<String, dynamic> json) => Courses(
        courseId: json['_id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        // instructorId: json['instructorId'] as String,
        // price: json['price'] as double,
        thumbnail: json['thumbnail'] as String,
        url: json['url'] as String,
        publishedDate: json['publishedDate'],
        channelName: json['channelName'] as String,
        toolRelatedTo: json['toolRelatedTo'] as String,
      );

  Map<String, dynamic> toJson() => {
        'courseId': courseId,
        'title': title,
        'description': description,
        // 'instructorId': instructorId,
        // 'price': price,
        'thumbnail': thumbnail,
        'url': url,
        'publishedDate': publishedDate,
        'channelName': channelName,
        'toolRelatedTo': toolRelatedTo,
      };
}
