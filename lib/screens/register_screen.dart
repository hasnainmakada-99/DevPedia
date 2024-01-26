import 'package:devpedia/auth/auth_provider.dart';
import 'package:devpedia/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateChangesProvider);

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
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Enter your Email',
              border: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Enter your Password',
              border: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Confirm your Password',
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
        onPressed: () async {
          final email = emailController.text;
          final password = passwordController.text;
          final confirmPassword = confirmPasswordController.text;
          if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please fill in all the fields.'),
              ),
            );
            return;
          }

          if (password != confirmPassword) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Passwords do not match.'),
              ),
            );
            return;
          } else {
            try {
              if (authState.value!.email == email) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('User already exists.'),
                  ),
                );
                return;
              }
              await ref.read(authRepositoryProvider).signUp(
                    email,
                    password,
                    ref,
                  );

              // ignore: use_build_context_synchronously
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            } catch (e) {
              rethrow;
            }
          }
        },
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
      ),
    );
  }
}
