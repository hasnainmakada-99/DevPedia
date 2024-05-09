import 'dart:ffi';

import 'package:devpedia/auth/auth_provider.dart';
import 'package:devpedia/others/password_field.dart';
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
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/devpedia_logo.png'),
                  radius: 90,
                ),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Enter your Email',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.deepPurple[50],
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Enter your Password',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.deepPurple[50],
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 90),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 53, 51, 56),
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: isLoading ? null : _handleLogin,
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        )
                      : Text(
                          'Login',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                onPressed: _navigateToRegisterScreen,
                child: Text(
                  'Not registered yet? Register now.',
                  style: TextStyle(color: Color.fromARGB(255, 53, 51, 56)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    setState(() {
      isLoading = true;
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      await ref.read(authRepositoryProvider).signIn(email, password);

      setState(() {
        isLoading = false;
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _navigateToRegisterScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterScreen(),
      ),
      (route) => false,
    );
  }
}
