import 'package:eventify/auth/domain/use_cases/login_use_case.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventify/calendar/presentation/screen/calendar_screen.dart'; // Importa la pantalla del calendario

class SignInViewModel extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  BuildContext? _context; // Almacena el contexto

  SignInViewModel({required this.loginUseCase});

  // Método para iniciar sesión con Firebase, llamado desde la UI
  Future<void> signInWithFirebase(BuildContext context, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    _context = context; // Guarda el contexto
    notifyListeners();

    try {
      final UserCredential? userCredential = await loginUseCase.execute(email, password); // Llama al caso de uso
      if (userCredential != null) {
        // Manejar el éxito en el ViewModel
        print('Inicio de sesión exitoso: ${userCredential.user?.email}');
        _isLoading = false;
        notifyListeners();
        // Navega a la pantalla del calendario después de un inicio de sesión exitoso
        if (_context != null) {
          Navigator.of(_context!).pushReplacement(
            MaterialPageRoute(builder: (_) => const CalendarScreen()),
          );
        }
      } else {
        _isLoading = false;
        _errorMessage = 'Inicio de sesión fallido';
        notifyListeners();
        if (_context != null) {
          ScaffoldMessenger.of(_context!).showSnackBar(
            const SnackBar(content: Text('Inicio de sesión fallido')),
          );
        }
      }
    } catch (error) {
      // Manejar el error
      _isLoading = false;
      _errorMessage = error.toString();
      notifyListeners();
       if (_context != null) {
          ScaffoldMessenger.of(_context!).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        }
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}