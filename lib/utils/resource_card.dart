import 'package:devpedia/resources%20screens/resource_info.dart';
import 'package:devpedia/utils/shareResource_func.dart';
import 'package:flutter/material.dart';

class ResourceCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String shareLink;

  final Function navigateTo;

  const ResourceCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.shareLink,
    required this.navigateTo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      child: InkWell(
        onTap: () => navigateTo(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(
              imageUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Handle image loading errors (e.g., show placeholder)
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
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey[800],
                    ),
                  ),
                  Container(height: 10),
                  Text(
                    description.length > 60
                        ? '${description.substring(0, 60)}...'
                        : description,
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
                          await shareResource(title, shareLink);
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.transparent,
                        ),
                        child: const Text(
                          "EXPLORE",
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () {
                          navigateTo();
                          // Handle explore action
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(height: 5),
          ],
        ), // This adds the shadow to the card
      ),
    );
  }
}
