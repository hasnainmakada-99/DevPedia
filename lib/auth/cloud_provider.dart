import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final cloudProvider = Provider<CloudRepository>((ref) => CloudRepository());

class CloudRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addFeedback(double ratings, String feedbackDescription,
      String userEmail, String ResourceTool) async {
    try {
      final querySnapshot = await _firestore
          .collection('userFeedback')
          .where('userEmail', isEqualTo: userEmail)
          .where('ResourceTool', isEqualTo: ResourceTool)
          .get(); // check if user has already given feedback for the resource

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot
            .docs.first.id; // get the document ID of the user feedback
        await _firestore.collection('userFeedback').doc(docId).update({
          // updates the existing feedback
          'ratings': ratings,
          'feedbackDescription': feedbackDescription,
        });
        // print('Feedback updated successfully');
      } else {
        await _firestore.collection('userFeedback').add({
          // if the user does not exists, then it adds the feedback as a new input to the collection of userFeedbacks
          'userEmail': userEmail,
          'ratings': ratings,
          'feedbackDescription': feedbackDescription,
          'ResourceTool': ResourceTool,
        });
      }
    } catch (e) {
      rethrow;
    }
  }
}
