import 'package:eventify/auth/domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import '../repositories/auth_repository.dart';
import 'dart:developer'; // Import for log
import 'package:eventify/common/constants/app_logs.dart';

class GoogleSignInUseCase {
  final AuthRepository authRepository;

  GoogleSignInUseCase({required this.authRepository});

  Future<User?> execute() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // User cancelled the sign-in flow
        log(AppLogs.googleSignInCancelled, name: 'GoogleSignInUseCase');
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final firebase_auth.OAuthCredential credential = firebase_auth
          .GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final firebase_auth.UserCredential userCredential = await firebase_auth
          .FirebaseAuth
          .instance
          .signInWithCredential(credential);
      final firebase_auth.User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        log(
          AppLogs.googleSignInAuthenticated + firebaseUser.uid,
          name: 'GoogleSignInUseCase',
        );
        // Save user info to Firestore if it's a new user or update existing
        return await authRepository.signInWithGoogle(firebaseUser);
      } else {
        log(AppLogs.googleSignInNullUser, name: 'GoogleSignInUseCase');
        throw Exception(AppLogs.googleSignInNullUser);
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      log(
        AppLogs.googleSignInFirebaseAuthError + "${e.code} - ${e.message}",
        name: 'GoogleSignInUseCase',
        error: e,
      );
      rethrow; // Rethrow Firebase specific exceptions
    } catch (e) {
      log(
        AppLogs.googleSignInUnexpectedError + e.toString(),
        name: 'GoogleSignInUseCase',
        error: e,
      );
      throw Exception(
        AppLogs.googleSignInUnexpectedError + e.toString(),
      ); // Rethrow generic errors
    }
  }
}
