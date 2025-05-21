import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginUseCase({required this.repository});
  Future<UserCredential?> execute(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      log("LoginUseCase error: $e");
      rethrow;
    }
  }
}