import 'package:eventify/auth/domain/entities/user.dart';
import 'package:eventify/auth/domain/use_cases/register_use_case.dart';
import 'package:flutter/material.dart';

class SignUpViewModel extends ChangeNotifier {
  final RegisterUseCase registerUseCase;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  User? _registeredUser;
  User? get registeredUser => _registeredUser;

  SignUpViewModel({required this.registerUseCase});

  Future<bool> register(String email, String password, String username) async {
    _setLoadingState(true);
    _setErrorMessage(null);

    try {
      _registeredUser = await registerUseCase.execute(email, password, username);
      if (_registeredUser != null) {
        _setLoadingState(false);
        return true;
      } else {
        _setErrorMessage('Registration failed. Please try again.');
        _setLoadingState(false);
        return false;
      }
    } catch (e) {
      _setLoadingState(false);
      _setErrorMessage('An error occurred: $e');
      return false;
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