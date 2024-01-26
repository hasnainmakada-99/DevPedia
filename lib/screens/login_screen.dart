// Login screen after the user has successfully registered themselves along with a note for the users who has not registred redirecting them to the registration screen.

import 'package:devpedia/screens/register_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: FlutterLogo(
                size: 100,
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                'Login',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                // Implement your login logic here
              },
            ),
            SizedBox(height: 10),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: Text('Not registered yet? Register now.'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
