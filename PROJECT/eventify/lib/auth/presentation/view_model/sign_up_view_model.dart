import 'package:eventify/auth/domain/entities/user.dart' as domain;
import 'package:eventify/auth/domain/use_cases/google_sign_in_use_case.dart';
import 'package:eventify/auth/domain/use_cases/register_use_case.dart';
import 'package:eventify/calendar/presentation/screen/calendar/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
class SignUpViewModel extends ChangeNotifier {
  final RegisterUseCase registerUseCase;
  final GoogleSignInUseCase googleSignInUseCase;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  domain.User? _registeredUser;
  domain.User? get registeredUser => _registeredUser;

  SignUpViewModel({required this.registerUseCase, required this.googleSignInUseCase});

  Future<bool> register(String email, String password, String username) async {
    _setLoadingState(true);
    _setErrorMessage(null);
    try {
      final user = await registerUseCase.execute(email, password, username);
      if (user != null) {
        _registeredUser = user;
        _setLoadingState(false);
        return true;
      } else {
        _setErrorMessage(AppInternalConstants.signUpFailure); // Corrected to AppInternalConstants
        _setLoadingState(false);
        return false;
      }
    } catch (e) {
      _setLoadingState(false);
      _setErrorMessage('${AppInternalConstants.chatUnexpectedError}: $e');
      return false;
    }
  }

  Future<bool> signInWithGoogle(BuildContext context) async {
    _setLoadingState(true);
    _setErrorMessage(null);
    try {
      final user = await googleSignInUseCase.execute();
      if (user != null) {
        _registeredUser = user;
        _setLoadingState(false);

        print('User UID after Google Sign-In: ${FirebaseAuth.instance.currentUser?.uid}');

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (_) => const CalendarScreen()),
        );
        return true;
      } else {
        _setErrorMessage(AppInternalConstants.googleSignInCancelled); // Corrected to AppInternalConstants
        _setLoadingState(false);
        return false;
      }
    } on FirebaseAuthException catch (e) {
      _setErrorMessage('${AppInternalConstants.chatGeminiApiError}: ${e.message}');
      _setLoadingState(false);
      return false;
    } catch (e) {
      _setErrorMessage('${AppInternalConstants.chatUnexpectedError}: $e');
      _setLoadingState(false);
      return false;
    } finally {
      _setLoadingState(false);
    }
  }

  void _setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}
