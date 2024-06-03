import 'package:cloud_firestore/cloud_firestore.dart';

class Enrollment {
  final String enrollmentId;
  final String courseId;
  final String studentId;
  final DateTime enrollmentDate;

  Enrollment({
    required this.enrollmentId,
    required this.courseId,
    required this.studentId,
    required this.enrollmentDate,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) => Enrollment(
        enrollmentId: json['enrollmentId'] as String,
        courseId: json['courseId'] as String,
        studentId: json['studentId'] as String,
        enrollmentDate: (json['enrollmentDate'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
        'enrollmentId': enrollmentId,
        'courseId': courseId,
        'studentId': studentId,
        'enrollmentDate': enrollmentDate,
      };
}
