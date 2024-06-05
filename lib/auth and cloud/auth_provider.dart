// import 'dart:developer';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// final authRepositoryProvider = Provider<AuthRepository>(
//   (ref) => AuthRepository(),
// );

// final authStateChangesProvider = StreamProvider<User?>((ref) {
//   return ref.watch(authRepositoryProvider).authStateChanges;
// });

// class AuthRepository {
//   final _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   Stream<User?> get authStateChanges => _auth.authStateChanges();

//   String? get userEmail {
//     final user = _auth.currentUser;
//     return user?.email;
//   }

//   Future<void> signUp(String email, String password, WidgetRef ref) async {
//     try {
//       await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       User? user = _auth.currentUser;
//       if (user != null && !user.emailVerified) {
//         await user.sendEmailVerification();
//       }
//     } catch (e) {
//       log(e.toString());
//       rethrow;
//     }
//   }

//   Future<dynamic> signIn(String email, String password) async {
//     try {
//       await _auth.signInWithEmailAndPassword(email: email, password: password);
//       User? user = _auth.currentUser;
//       if (user != null && !user.emailVerified) {
//         throw FirebaseAuthException(
//           code: 'email-not-verified',
//           message: 'Please verify your email before signing in.',
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       rethrow;
//     } catch (e) {
//       log(e.toString());
//       rethrow;
//     }
//   }

//   Future<dynamic> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         // The user canceled the sign-in
//         return;
//       }
//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//       await _auth.signInWithCredential(credential);
//     } on FirebaseAuthException catch (e) {
//       rethrow;
//     } catch (e) {
//       log(e.toString());
//       rethrow;
//     }
//   }

//   Future<dynamic> forgotPassword(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//     } on FirebaseAuthException catch (e) {
//       rethrow;
//     } catch (e) {
//       log(e.toString());
//       rethrow;
//     }
//   }

//   Future<void> signOut() async {
//     try {
//       await _auth.signOut();
//       await _googleSignIn.signOut(); // Ensure Google sign-out
//     } on FirebaseAuthException catch (e) {
//       log(e.toString());
//     } catch (e) {
//       log(e.toString());
//     }
//   }
// }

// Testing Code

import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

class AuthRepository {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  String? get userEmail {
    final user = _auth.currentUser;
    return user?.email;
  }

  Future<void> signUp(
      String email, String password, dynamic imageFile, WidgetRef ref) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }

      if (user != null && imageFile != null) {
        // Upload the image to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_profiles')
            .child(user.uid);
        await storageRef.putFile(File(imageFile.path));

        // Get the download URL
        final imageUrl = await storageRef.getDownloadURL();

        // Update the user's profile with the image URL
        await user.updateProfile(photoURL: imageUrl);
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

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
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
