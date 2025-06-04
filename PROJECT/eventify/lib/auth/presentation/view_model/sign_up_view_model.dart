// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:eventify/auth/domain/entities/user.dart' as domain;
import 'package:eventify/auth/domain/use_cases/google_sign_in_use_case.dart';
import 'package:eventify/auth/domain/use_cases/register_use_case.dart';
import 'package:eventify/calendar/presentation/screen/calendar/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/common/constants/app_logs.dart';

class SignUpViewModel extends ChangeNotifier {
  final RegisterUseCase registerUseCase;
  final GoogleSignInUseCase googleSignInUseCase;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  domain.User? _registeredUser;
  domain.User? get registeredUser => _registeredUser;

  SignUpViewModel({
    required this.registerUseCase,
    required this.googleSignInUseCase,
  });

  // Establece el estado de carga y limpia el mensaje de error antes de intentar el registro
  Future<bool> register(String email, String password, String username) async {
    _setLoadingState(true);
    _setErrorMessage(null);
    try {
      // Ejecuta el caso de uso de registro
      final user = await registerUseCase.execute(email, password, username);
      if (user != null) {
        _registeredUser = user;
        _setLoadingState(false);
        return true;
      } else {
        // Si el usuario es nulo, muestra mensaje de fallo
        _setErrorMessage(AppInternalConstants.signUpFailure);
        _setLoadingState(false);
        return false;
      }
    } catch (e) {
      // Captura errores inesperados
      _setLoadingState(false);
      _setErrorMessage('${AppInternalConstants.chatUnexpectedError}: $e');
      return false;
    }
  }

  // Método alternativo para registrar usuario
  Future<bool> signUp(String email, String password, String username) async {
    return await register(email, password, username);
  }

  // Inicia sesión con Google y navega a la pantalla principal si es exitoso
  Future<bool> signInWithGoogle(BuildContext context) async {
    _setLoadingState(true);
    _setErrorMessage(null);
    try {
      final user = await googleSignInUseCase.execute();
      if (user != null) {
        _registeredUser = user;
        _setLoadingState(false);

        log(
          AppLogs.googleSignInUserUid +
              (FirebaseAuth.instance.currentUser?.uid ?? ''),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CalendarScreen()),
        );
        return true;
      } else {
        // Si el usuario cancela el inicio de sesión con Google
        _setErrorMessage(AppInternalConstants.googleSignInCancelled);
        _setLoadingState(false);
        return false;
      }
    } on FirebaseAuthException catch (e) {
      // Maneja errores específicos de Firebase
      _setErrorMessage(
        '${AppInternalConstants.chatGeminiApiError}: ${e.message}',
      );
      _setLoadingState(false);
      return false;
    } catch (e) {
      // Maneja otros errores inesperados
      _setErrorMessage('${AppInternalConstants.chatUnexpectedError}: $e');
      _setLoadingState(false);
      return false;
    } finally {
      _setLoadingState(false);
    }
  }

  // Actualiza el estado de carga y notifica a los listeners
  void _setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  // Actualiza el mensaje de error y notifica a los listeners
  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}
