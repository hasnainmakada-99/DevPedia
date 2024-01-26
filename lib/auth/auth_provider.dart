import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { loading, authenticated, unauthenticated, error }

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final currentUserProvider = StateProvider<User?>(
  (ref) => null,
);

class AuthRepository {
  final _auth = FirebaseAuth.instance;
  AuthStatus _status = AuthStatus.unauthenticated;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signup(String email, String password) async {
    try {
      _status = AuthStatus.loading;

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _status = AuthStatus.authenticated;
    } catch (e) {
      _status = AuthStatus.error;

      log(e.toString());
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _status = AuthStatus.unauthenticated;
    } catch (e) {
      _status = AuthStatus.error;

      throw e;
    }
  }

  // ... other authentication methods
}

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get user => _auth.currentUser;
  AuthStatus _status = AuthStatus.unauthenticated;

  AuthStatus get status => _status;

  Future<void> signIn(String email, String password) async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _status = AuthStatus.authenticated;
      notifyListeners();
    } catch (e) {
      _status = AuthStatus.error;
      notifyListeners();
      log(e.toString());
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    } catch (e) {
      _status = AuthStatus.error;
      notifyListeners();
      throw e;
    }
  }
}
