import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventify/common/constants/app_logs.dart';

import '../repositories/auth_repository.dart';

/// Caso de uso para iniciar sesión con email y contraseña
class LoginUseCase {
  final AuthRepository repository;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginUseCase({required this.repository});

  Future<UserCredential?> execute(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      log(AppLogs.loginUseCaseError + e.toString());
      rethrow;
    }
  }
}
