import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Feedback',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CourseFeedbackPage(),
    );
  }
}

class CourseFeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appbar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top image container
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              color: Colors.grey[300],
              child: Center(
                child: Icon(
                  Icons.image,
                  size: 50,
                  color: Colors.grey[700],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Instructor section
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  'Instructor Name',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Course description
            Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: Text(
                'Course Description',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Spacer(),

            // Give feedback button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Give Feedback'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
