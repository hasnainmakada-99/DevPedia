import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String userId;

  final String email;
  final String role; // "student" or "instructor"
  final String profilePicture;
  final String? bio; // Optional for instructors
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.userId,
    required this.email,
    required this.role,
    required this.profilePicture,
    this.bio,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json['userId'] as String,
        email: json['email'] as String,
        role: json['role'] as String,
        profilePicture: json['profilePicture'] as String,
        bio: json['bio'] as String?,
        createdAt: (json['createdAt'] as Timestamp).toDate(),
        updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'email': email,
        'role': role,
        'profilePicture': profilePicture,
        if (bio != null) 'bio': bio,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
