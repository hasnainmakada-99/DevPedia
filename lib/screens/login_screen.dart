// Login screen after the user has successfully registered themselves along with a note for the users who has not registred redirecting them to the registration screen.

import 'package:devpedia/auth/auth_provider.dart';
import 'package:devpedia/screens/dashboard_screen.dart';
import 'package:devpedia/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Enter your Email',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Enter your Password',
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
              onPressed: () async {
                final email = emailController.text.trim();
                final password = passwordController.text.trim();

                await ref.read(authRepositoryProvider).signIn(email, password);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()),
                  (route) => false,
                );
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
