import 'package:eventify/auth/domain/use_cases/login_use_case.dart';
import 'package:flutter/material.dart';

class SignInViewModel extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  SignInViewModel({required this.loginUseCase});

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    final success = await loginUseCase.execute(email, password);
    _isLoading = false;
    if (!success) {
      _errorMessage = 'Invalid email or password';
    }
    notifyListeners();
    return success;
  }
}