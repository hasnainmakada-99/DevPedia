import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:devpedia/auth/auth_provider.dart';

import 'package:devpedia/firebase_options.dart';
import 'package:devpedia/random_code/login_register.dart';

import 'package:devpedia/screens/dashboard_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: FlutterSplashScreen.gif(
      //   gifPath: 'assets/devpedia_logo.png',
      //   gifWidth: 269,
      //   gifHeight: 474,
      //   nextScreen: const MyHomePage(),
      //   duration: const Duration(milliseconds: 1000),
      //   onInit: () async {
      //     debugPrint("onInit");
      //   },
      //   onEnd: () async {
      //     debugPrint("onEnd 1");
      //   },

      home: AnimatedSplashScreen(
        splash: SvgPicture.asset(
          'assets/1.svg',
        ),
        nextScreen: const MyHomePage(),
        splashTransition: SplashTransition.rotationTransition,
        duration: 1000,
        splashIconSize: 150,
      ),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (data) {
        if (data != null && data.emailVerified) {
          return const DashboardScreen();
        } else {
          return const LoginRegister();
        }
      },
      error: (error, stackTrace) {
        return Scaffold(
          body: Center(
            child: Text(error.toString()),
          ),
        );
      },
      loading: () {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
