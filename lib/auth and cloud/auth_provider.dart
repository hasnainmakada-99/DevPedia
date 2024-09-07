import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../modals/users_modal.dart' as user_model;

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

class AuthRepository {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  String? get userEmail {
    final user = _auth.currentUser;
    return user?.email;
  }

  Future<void> signUp(
      String email, String password, dynamic imageFile, WidgetRef ref) async {
    try {
      // Create user with email and password
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = _auth.currentUser;

      // Send email verification
      if (firebaseUser != null && !firebaseUser.emailVerified) {
        await firebaseUser.sendEmailVerification();
      }

      // Set up a listener for email verification
      _auth.userChanges().listen((User? user) async {
        if (user != null && user.emailVerified) {
          String? imageUrl;

          // Upload the image to Firebase Storage
          if (imageFile != null) {
            final storageRef = FirebaseStorage.instance
                .ref()
                .child('user_profiles')
                .child(user.uid);
            await storageRef.putFile(File(imageFile.path));

            // Get the download URL
            imageUrl = await storageRef.getDownloadURL();
          }

          // Update the user's profile with the image URL
          await user.updatePhotoURL(imageUrl);

          // Create user in Firestore
          final newUser = user_model.User(
            userId: user.uid,

            email: user.email!,
            role: 'student', // or determine the role dynamically
            profilePicture: imageUrl ?? '',
            bio: null,
            createdAt: DateTime.timestamp(),
            updatedAt: DateTime.timestamp(),
          );

          await _firestore
              .collection('users')
              .doc(newUser.userId)
              .set(newUser.toJson());
        }
      });
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

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // User canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user; // Return the signed-in user
    } catch (e) {
      log('Error signing in with Google: $e');
      return null; // Return null on error
    }
  }

  Future<dynamic> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
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
      await _googleSignIn.signOut(); // Ensure Google sign-out
    } on FirebaseAuthException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }
}
