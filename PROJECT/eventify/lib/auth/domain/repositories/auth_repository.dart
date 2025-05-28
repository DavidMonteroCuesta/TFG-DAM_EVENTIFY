import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../domain/entities/user.dart';

abstract class AuthRepository {
  Future<firebase_auth.UserCredential?> login(String email, String password);
  Future<User?> register(String email, String password, String username);
  Future<User?> signInWithGoogle(firebase_auth.User firebaseUser);
  Future<void> sendPasswordResetEmail(String email);
}
