import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpedia/modals/review_modal.dart';
import 'package:devpedia/modals/enrollments_modal.dart';

final cloudProvider = Provider<CloudRepository>((ref) => CloudRepository());

class CloudRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addFeedback(Review review) async {
    try {
      final querySnapshot = await _firestore
          .collection('userFeedback')
          .where('studentId', isEqualTo: review.studentId)
          .where('courseId', isEqualTo: review.courseId)
          .get(); // check if user has already given feedback for the resource

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot
            .docs.first.id; // get the document ID of the user feedback
        await _firestore
            .collection('userFeedback')
            .doc(docId)
            .update(review.toJson());
      } else {
        await _firestore.collection('userFeedback').add(review.toJson());
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> enrollInCourse(Enrollment enrollment) async {
    try {
      await _firestore.collection('enrollments').add(enrollment.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkEnrollment(String courseId, String studentId) async {
    try {
      final querySnapshot = await _firestore
          .collection('enrollments')
          .where('courseId', isEqualTo: courseId)
          .where('studentId', isEqualTo: studentId)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }
}
