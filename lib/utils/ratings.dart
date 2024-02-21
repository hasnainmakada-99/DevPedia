import 'package:cloud_firestore/cloud_firestore.dart';

void storeRating(double rating) async {
  CollectionReference ratings =
      FirebaseFirestore.instance.collection('ratings');
  await ratings.add(
    {
      'rating': rating,
      'timestamp': DateTime.now(),
    },
  );
}
