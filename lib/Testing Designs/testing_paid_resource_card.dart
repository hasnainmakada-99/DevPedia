import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class PaidResourceCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String shareLink;
  final String price;
  final Function onPayment;

  const PaidResourceCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.shareLink,
    required this.price,
    required this.onPayment,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: [
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
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  color: Colors.black54,
                  child: Text(
                    '\₹${price}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
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
                        await Share.share(
                          'Check out this resource: $title\n $shareLink\n ',
                        );
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.transparent,
                      ),
                      child: const Text(
                        "PAY TO ACCESS",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {
                        onPayment();
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
    );
  }
}
