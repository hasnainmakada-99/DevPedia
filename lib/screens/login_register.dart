// import 'package:devpedia/auth%20and%20cloud/auth_provider.dart';
// import 'package:devpedia/random_code/forgot_pass.dart';
// import 'package:devpedia/screens/dashboard_screen.dart';
// import 'package:devpedia/utils/alert_dialog.dart';
// import 'package:devpedia/utils/showAlert.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';

// class LoginRegister extends ConsumerStatefulWidget {
//   const LoginRegister({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _LoginFormState();
// }

// class _LoginFormState extends ConsumerState<LoginRegister> {
//   bool isNewUser = false;
//   TextEditingController loginEmailController = TextEditingController();
//   TextEditingController loginPasswordController = TextEditingController();
//   bool isLoading = false;
//   TextEditingController registerEmailController = TextEditingController();
//   TextEditingController registerPasswordController = TextEditingController();
//   TextEditingController confirmPasswordController = TextEditingController();
//   // final authState = ref.watch(authRepositoryProvider);
//   void _handleLogin() async {
//     setState(() {
//       isLoading = true;
//     });

//     final email = loginEmailController.text.trim();
//     final password = loginPasswordController.text.trim();

//     try {
//       await ref.read(authRepositoryProvider).signIn(email, password);

//       setState(() {
//         isLoading = false;
//       });

//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const DashboardScreen(),
//         ),
//         (route) => false,
//       );
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });

//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Error'),
//             content: Text(e.toString()),
//             actions: [
//               TextButton(
//                 child: Text('OK'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   void _handleRegister(BuildContext context) async {
//     final authState = ref.watch(authStateChangesProvider);
//     final email = registerEmailController.text.trim();
//     final password = registerPasswordController.text.trim();
//     final confirmPassword = confirmPasswordController.text;
//     if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please fill in all the fields.'),
//         ),
//       );
//       return;
//     }

//     if (password != confirmPassword) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Passwords do not match.'),
//         ),
//       );
//       return;
//     } else {
//       setState(() {
//         isLoading = true;
//       });

//       try {
//         if (authState.value != null && authState.value!.email == email) {
//           return showAlert(
//             context,
//             'User already exists with Different Credential',
//           );
//         }
//         await ref.read(authRepositoryProvider).signUp(
//               email,
//               password,
//               ref,
//             );

//         showAlertDialog(
//           context: context,
//           titleText: 'Please Check your Spam/Inbox for email verifications',
//           contentText: 'And once verified please login',
//           onReject: () {
//             Navigator.of(context).pop();
//             registerEmailController.clear();
//             registerPasswordController.clear();
//             confirmPasswordController.clear();
//           },
//           onApprove: () {
//             Navigator.of(context).pop();
//             registerEmailController.clear();
//             registerPasswordController.clear();
//             confirmPasswordController.clear();
//           },
//         );
//       } catch (e) {
//         rethrow;
//       } finally {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Center(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 40),
//                   Text(
//                     'Welcome to DevPedia',
//                     style: GoogleFonts.lato(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   ToggleButtons(
//                     borderRadius: BorderRadius.circular(8),
//                     isSelected: [!isNewUser, isNewUser],
//                     onPressed: (int index) {
//                       setState(() {
//                         isNewUser = index == 1;
//                       });
//                     },
//                     children: const [
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0),
//                         child: Text('Sign in'),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0),
//                         child: Text('New User?'),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   if (!isNewUser)
//                     Column(
//                       children: [
//                         TextField(
//                           controller: loginEmailController,
//                           decoration: InputDecoration(
//                             labelText: 'E-mail',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         TextField(
//                           controller: loginPasswordController,
//                           obscureText: true,
//                           decoration: InputDecoration(
//                             labelText: 'Enter password',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: TextButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       const ForgotPasswordScreen(),
//                                 ),
//                               );
//                             },
//                             child: const Text('Forgot password?'),
//                           ),
//                         ),
//                       ],
//                     ),
//                   if (isNewUser)
//                     Column(
//                       children: [
//                         TextField(
//                           controller: registerEmailController,
//                           decoration: InputDecoration(
//                             labelText: 'E-mail',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         TextField(
//                           controller: registerPasswordController,
//                           obscureText: true,
//                           decoration: InputDecoration(
//                             labelText: 'Enter password',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         TextField(
//                           controller: confirmPasswordController,
//                           obscureText: true,
//                           decoration: InputDecoration(
//                             labelText: 'Confirm password',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   const SizedBox(height: 15),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (isNewUser) {
//                         _handleRegister(context);
//                       } else {
//                         _handleLogin();
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size(double.infinity, 50),
//                       backgroundColor: Colors.black,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: isLoading
//                         ? const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(),
//                           )
//                         : Text(
//                             isNewUser ? 'Sign Up' : 'Sign In',
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                   ),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// GOOGLE SIGN IN TESTING CODE

import 'package:devpedia/auth%20and%20cloud/auth_provider.dart';
import 'package:devpedia/screens/forgot_pass.dart';
import 'package:devpedia/screens/dashboard_screen.dart';
import 'package:devpedia/utils/alert_dialog.dart';
import 'package:devpedia/utils/showAlert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginRegister extends ConsumerStatefulWidget {
  const LoginRegister({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginRegister> {
  bool isNewUser = false;
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  bool isLoading = false;
  bool isGoogleLoading = false;
  TextEditingController registerEmailController = TextEditingController();
  TextEditingController registerPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void _handleLogin() async {
    setState(() {
      isLoading = true;
    });

    final email = loginEmailController.text.trim();
    final password = loginPasswordController.text.trim();

    try {
      await ref.read(authRepositoryProvider).signIn(email, password);

      setState(() {
        isLoading = false;
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
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
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                child: const Text('OK'),
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

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      isGoogleLoading = true;
    });

    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();

      setState(() {
        isGoogleLoading = false;
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      setState(() {
        isGoogleLoading = false;
      });

      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                child: const Text('OK'),
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

  void _handleRegister(BuildContext context) async {
    final authState = ref.watch(authStateChangesProvider);
    final email = registerEmailController.text.trim();
    final password = registerPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text;
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
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
        if (authState.value != null && authState.value!.email == email) {
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

        showAlertDialog(
          context: context,
          titleText: 'Please Check your Spam/Inbox for email verifications',
          contentText: 'And once verified please login',
          onReject: () {
            Navigator.of(context).pop();
            registerEmailController.clear();
            registerPasswordController.clear();
            confirmPasswordController.clear();
          },
          onApprove: () {
            Navigator.of(context).pop();
            registerEmailController.clear();
            registerPasswordController.clear();
            confirmPasswordController.clear();
          },
        );
      } catch (e) {
        rethrow;
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Welcome to DevPedia',
                    style: GoogleFonts.lato(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ToggleButtons(
                    borderRadius: BorderRadius.circular(8),
                    isSelected: [!isNewUser, isNewUser],
                    onPressed: (int index) {
                      setState(() {
                        isNewUser = index == 1;
                      });
                    },
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Sign in'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('New User?'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (!isNewUser)
                    Column(
                      children: [
                        TextField(
                          controller: loginEmailController,
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: loginPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Enter password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 300,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: Colors.black),
                              ),
                              backgroundColor:
                                  Color.fromARGB(255, 224, 219, 219),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator()
                                : const Text(
                                    'Sign in',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('or'),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 300,
                          height: 80,
                          child: ElevatedButton.icon(
                            onPressed:
                                isGoogleLoading ? null : _handleGoogleSignIn,
                            icon: isGoogleLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  )
                                : Image.asset(
                                    'assets/google_logo.webp',
                                    height: 50.0,
                                    width: 50.0,
                                  ),
                            label: isGoogleLoading
                                ? const SizedBox.shrink()
                                : const Text(
                                    'Sign in with Gmail   ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: Colors.black),
                              ),
                              backgroundColor:
                                  Color.fromARGB(255, 224, 219, 219),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (isNewUser)
                    Column(
                      children: [
                        TextField(
                          controller: registerEmailController,
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: registerPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Enter password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Confirm password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 300,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    _handleRegister(context);
                                  },
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: Colors.black),
                              ),
                              backgroundColor:
                                  Color.fromARGB(255, 224, 219, 219),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator()
                                : const Text(
                                    'Register',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
