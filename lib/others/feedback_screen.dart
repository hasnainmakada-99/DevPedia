import 'package:devpedia/auth%20and%20cloud/auth_provider.dart';
import 'package:devpedia/auth%20and%20cloud/cloud_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  final String resourceRelatedTo;
  const FeedbackScreen({Key? key, required this.resourceRelatedTo})
      : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  String resourceTitle = '';
  double ratings = 0.0;
  String feedbackDescription = '';

  TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userEmail = ref.watch(authStateChangesProvider).value!.email;
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
                onPressed: () {
                  String feedbackDescription =
                      feedbackController.text.trim().toLowerCase();
                  bool isfeedbackProvided = false;
                  if (feedbackDescription.isNotEmpty && ratings != 0.0) {
                    ref.watch(cloudProvider).addFeedback(
                          ratings,
                          feedbackDescription,
                          userEmail!,
                          widget.resourceRelatedTo,
                        );
                    isfeedbackProvided = true;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please provide some feedback'),
                      ),
                    );
                  }

                  if (isfeedbackProvided) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Feedback provided successfully'),
                      ),
                    );
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
