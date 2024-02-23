import 'package:firebase_auth/firebase_auth.dart';
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
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;
        await _firestore.collection('userFeedback').doc(docId).update({
          'ratings': ratings,
          'feedbackDescription': feedbackDescription,
        });
        print('Feedback updated successfully');
      } else {
        await _firestore.collection('userFeedback').add({
          'userEmail': userEmail,
          'ratings': ratings,
          'feedbackDescription': feedbackDescription,
          'ResourceTool': ResourceTool,
        });
        print('Feedback added successfully');
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
