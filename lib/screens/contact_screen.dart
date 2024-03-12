import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  final String email = 'Hasnainmakada@gmail.com';
  final String phoneNumber = '+91 9638226174';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Card(
              child: ListTile(
                leading: const Icon(Icons.email),
                title: Text(email),
                onTap: () => _launchURL('mailto:$email'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone),
                title: Text(phoneNumber),
                onTap: () => _launchURL('tel:$phoneNumber'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
