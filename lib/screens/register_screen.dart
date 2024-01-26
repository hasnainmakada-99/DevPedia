import 'package:devpedia/screens/login_screen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The logo
    final Widget logo = Container(
      margin: EdgeInsets.only(bottom: 20),
      child: FlutterLogo(
        size: 100,
      ),
    );

    // The registration form
    final Widget form = Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              border: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );

    // The register button
    final Widget registerButton = Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: () {},
        child: Text(
          'Register',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );

    // The registration screen
    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  logo,
                  SizedBox(height: 20),
                  form,
                  SizedBox(height: 20),
                  registerButton,
                  SizedBox(height: 40),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: Text('Not registered yet? Register now.'),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
