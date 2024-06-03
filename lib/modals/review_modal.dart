import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String reviewId;
  final String courseId;
  final String studentId;
  final double rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.reviewId,
    required this.courseId,
    required this.studentId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        reviewId: json['reviewId'] as String,
        courseId: json['courseId'] as String,
        studentId: json['studentId'] as String,
        rating: json['rating'] as double,
        comment: json['comment'] as String,
        createdAt: (json['createdAt'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
        'reviewId': reviewId,
        'courseId': courseId,
        'studentId': studentId,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt,
      };
}
