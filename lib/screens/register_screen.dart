import 'package:devpedia/auth/auth_provider.dart';
import 'package:devpedia/others/password_field.dart';
import 'package:devpedia/screens/dashboard_screen.dart';
import 'package:devpedia/screens/login_screen.dart';
import 'package:devpedia/utils/showAlert.dart';
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
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateChangesProvider);

    final Widget logo = Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: CircleAvatar(
        backgroundImage: AssetImage('assets/devpedia_logo.png'),
        radius: 100,
      ),
    );

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
          FancyPasswordField1(),
          // TextFormField(
          //   controller: passwordController,
          //   obscureText: true,
          //   decoration: InputDecoration(
          //     labelText: 'Enter your Password',
          //     border: OutlineInputBorder(),
          //   ),
          //   style: TextStyle(fontSize: 16),
          // ),
          SizedBox(height: 10),
          FancyPasswordField1(),
          // TextFormField(
          //   controller: confirmPasswordController,
          //   obscureText: true,
          //   decoration: InputDecoration(
          //     labelText: 'Confirm your Password',
          //     border: OutlineInputBorder(),
          //   ),
          //   style: TextStyle(fontSize: 16),
          // ),
        ],
      ),
    );

    final Widget registerButton = Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 90),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 53, 51, 56),
          padding: EdgeInsets.symmetric(vertical: 10),
        ),
        onPressed: isLoading
            ? null
            : () async {
                final email = emailController.text;
                final password = passwordController.text;
                final confirmPassword = confirmPasswordController.text;
                if (email.isEmpty ||
                    password.isEmpty ||
                    confirmPassword.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all the fields.'),
                    ),
                  );
                  return;
                }

                if (password != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Passwords do not match.'),
                    ),
                  );
                  return;
                } else {
                  setState(() {
                    isLoading = true;
                  });

                  try {
                    if (authState.value != null &&
                        authState.value!.email == email) {
                      return showAlert(
                        context,
                        'User already exists with Different Credential',
                      );
                    }
                    await ref.read(authRepositoryProvider).signUp(
                          email,
                          password,
                          ref,
                        );

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DashboardScreen()),
                      (route) => false,
                    );
                  } catch (e) {
                    rethrow;
                  } finally {
                    setState(() {
                      isLoading = false;
                    });
                  }
                }
              },
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : const Text(
                'Register',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    logo,
                    const SizedBox(height: 20),
                    form,
                    const SizedBox(height: 20),
                    registerButton,
                    const SizedBox(height: 40),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Already have an account? Login',
                        style:
                            TextStyle(color: Color.fromARGB(255, 53, 51, 56)),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
