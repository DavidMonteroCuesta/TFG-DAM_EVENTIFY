import 'package:eventify/auth/domain/use_cases/register_use_case.dart';
import 'package:flutter/material.dart';

class SignUpViewModel extends ChangeNotifier {
  final RegisterUseCase registerUseCase;

  // Estado de carga
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Mensaje de error
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  SignUpViewModel({required this.registerUseCase});

  // Método de registro
  Future<bool> register(String email, String password) async {
    _setLoadingState(true);
    _setErrorMessage(null);

    try {
      final success = await registerUseCase.execute(email, password);
      if (success) {
        _setLoadingState(false);
      } else {
        _setErrorMessage('Registration failed. Please try again.');
        _setLoadingState(false);
      }
      return success;
    } catch (e) {
      _setLoadingState(false);
      _setErrorMessage('An error occurred. Please try again.');
      return false;
    }
  }

  // Métodos auxiliares para actualizar el estado
  void _setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}
