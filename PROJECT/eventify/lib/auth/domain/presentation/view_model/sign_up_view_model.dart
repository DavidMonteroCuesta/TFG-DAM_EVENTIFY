import 'package:eventify/auth/domain/use_cases/register_use_case.dart';
import 'package:flutter/material.dart';

class SignUpViewModel extends ChangeNotifier {
  final RegisterUseCase registerUseCase;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  SignUpViewModel({required this.registerUseCase});

  Future<bool> register(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    final success = await registerUseCase.execute(email, password);
    _isLoading = false;
    if (!success) {
      _errorMessage = 'Registration failed. Please try again.';
    }
    notifyListeners();
    return success;
  }
}