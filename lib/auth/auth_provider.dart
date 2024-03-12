import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

class AuthRepository {
  final _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth
      .authStateChanges(); // gets the stream of user authentication state changes from firebase auth

  String? get userEmail {
    final user = _auth.currentUser;
    return user?.email;
  }

  Future<void> signUp(String email, String password, WidgetRef ref) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<dynamic> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Please verify your email before signing in.',
        );
      }
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }
}
