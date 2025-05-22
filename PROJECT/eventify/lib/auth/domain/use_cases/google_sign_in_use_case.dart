import 'package:eventify/auth/domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import '../repositories/auth_repository.dart';
import 'dart:developer'; // Import for log

class GoogleSignInUseCase {
  final AuthRepository authRepository;

  GoogleSignInUseCase({required this.authRepository});

  Future<User?> execute() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // User cancelled the sign-in flow
        log('Google Sign-In cancelled by user.', name: 'GoogleSignInUseCase');
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final firebase_auth.OAuthCredential credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final firebase_auth.UserCredential userCredential = await firebase_auth.FirebaseAuth.instance.signInWithCredential(credential);
      final firebase_auth.User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        log('Firebase user authenticated via Google: ${firebaseUser.uid}', name: 'GoogleSignInUseCase');
        // Save user info to Firestore if it's a new user or update existing
        return await authRepository.signInWithGoogle(firebaseUser);
      } else {
        log('Firebase user is null after Google sign-in credential.', name: 'GoogleSignInUseCase');
        throw Exception('Firebase user is null after Google sign-in credential.');
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      log('Firebase Auth Error during Google Sign-In: ${e.code} - ${e.message}', name: 'GoogleSignInUseCase', error: e);
      rethrow; // Rethrow Firebase specific exceptions
    } catch (e) {
      log('Unexpected Error during Google Sign-In: $e', name: 'GoogleSignInUseCase', error: e);
      throw Exception('An unexpected error occurred during Google Sign-In: $e'); // Rethrow generic errors
    }
  }
}
