import 'package:devpedia/auth%20and%20cloud/auth_provider.dart';
import 'package:devpedia/auth%20and%20cloud/cloud_provider.dart';
import 'package:devpedia/modals/review_modal.dart';
import 'package:devpedia/utils/showAlert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  final String resourceRelatedTo;
  const FeedbackScreen({Key? key, required this.resourceRelatedTo})
      : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  double ratings = 0.0;
  TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateChangesProvider).value;
    if (user == null) {
      // Handle the case where the user is not logged in
      return Scaffold(
        appBar: AppBar(
          title: const Text('Feedback'),
        ),
        body: const Center(
          child: Text('You must be logged in to provide feedback.'),
        ),
      );
    }
    final userEmail = user.email;
    final userId = user.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("We would like to know your opinion",
                  style: TextStyle(fontSize: 18.0)),
              const SizedBox(height: 10.0),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    ratings = rating;
                  });
                },
              ),
              const SizedBox(height: 30.0),
              Flexible(
                child: TextField(
                  controller: feedbackController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: 'Any further problems or suggestions?',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () async {
                  String feedbackDescription =
                      feedbackController.text.trim().toLowerCase();
                  bool isFeedbackProvided = false;
                  if (feedbackDescription.isNotEmpty && ratings != 0.0) {
                    // Generate a unique reviewId
                    String reviewId = const Uuid().v4();

                    // Create a Review object
                    Review review = Review(
                      reviewId: reviewId,
                      courseId: widget.resourceRelatedTo,
                      studentId: userId,
                      rating: ratings,
                      comment: feedbackDescription,
                      createdAt: DateTime.now(),
                    );

                    // Save the review using cloudProvider
                    await ref.read(cloudProvider).addFeedback(review);
                    isFeedbackProvided = true;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please provide some feedback'),
                      ),
                    );
                  }

                  if (isFeedbackProvided) {
                    showAlert(context, "Thanks for your valuable feedback!");
                    setState(() {
                      ratings = 0.0;
                      feedbackController.clear();
                    });
                  }
                },
                child: const Text('Submit Feedback'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
