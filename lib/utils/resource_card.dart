import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:devpedia/auth%20and%20cloud/auth_provider.dart';
import 'package:devpedia/auth%20and%20cloud/cloud_provider.dart';
import 'package:devpedia/modals/enrollments_modal.dart';
import 'package:uuid/uuid.dart';

class ResourceCard extends ConsumerStatefulWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String shareLink;
  final String courseId;
  final Function navigateTo;

  const ResourceCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.shareLink,
    required this.courseId,
    required this.navigateTo,
  }) : super(key: key);

  @override
  _ResourceCardState createState() => _ResourceCardState();
}

class _ResourceCardState extends ConsumerState<ResourceCard> {
  bool _isEnrolled = false;

  @override
  void initState() {
    super.initState();
    _checkEnrollmentStatus();
  }

  Future<void> _checkEnrollmentStatus() async {
    final user = ref.read(authStateChangesProvider).value;
    if (user != null) {
      final isEnrolled = await ref
          .read(cloudProvider)
          .checkEnrollment(widget.courseId, user.uid);
      setState(() {
        _isEnrolled = isEnrolled;
      });
    }
  }

  Future<void> _enrollInCourse() async {
    final user = ref.read(authStateChangesProvider).value;
    if (user != null) {
      final enrollment = Enrollment(
        enrollmentId: const Uuid().v4(),
        courseId: widget.courseId,
        studentId: user.uid,
        enrollmentDate: DateTime.now(),
      );
      await ref.read(cloudProvider).enrollInCourse(enrollment);
      setState(() {
        _isEnrolled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      child: GestureDetector(
        onTap: _isEnrolled ? () => widget.navigateTo() : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(
              widget.imageUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 160,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Text('Error loading image'),
                  ),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey[800],
                    ),
                  ),
                  Container(height: 10),
                  Text(
                    widget.description.length > 60
                        ? '${widget.description.substring(0, 60)}...'
                        : widget.description,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.transparent,
                        ),
                        child: const Text(
                          "SHARE",
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () async {
                          await Share.share(
                            'Check out this resource: ${widget.title}\n ${widget.shareLink}\n ',
                          );
                        },
                      ),
                      _isEnrolled
                          ? const Text(
                              "In Progress",
                              style: TextStyle(color: Colors.green),
                            )
                          : TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.transparent,
                              ),
                              child: const Text(
                                "ENROLL",
                                style: TextStyle(color: Colors.blue),
                              ),
                              onPressed: () async {
                                await _enrollInCourse();
                              },
                            ),
                    ],
                  ),
                ],
              ),
            ),
            Container(height: 5),
          ],
        ),
      ),
    );
  }
}
