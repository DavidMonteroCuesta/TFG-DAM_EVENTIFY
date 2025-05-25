import 'package:eventify/auth/domain/use_cases/login_use_case.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventify/calendar/presentation/screen/calendar_screen.dart'; // Import the calendar screen
import 'package:eventify/common/constants/app_strings.dart'; // Import AppStrings

class SignInViewModel extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  BuildContext? _context; // Store the context

  SignInViewModel({required this.loginUseCase}) {
       // No need to check current user here. We do it in main.dart
  }

  // Method to initialize the view model with the context
  void initialize(BuildContext context) {
    _context = context;
  }


  // Method to sign in with Firebase, called from the UI
  Future<void> signInWithFirebase(BuildContext context, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    _context = context; // Store the context
    notifyListeners();

    try {
      final UserCredential? userCredential = await loginUseCase.execute(email, password); // Call the use case
      if (userCredential != null) {
        // Handle success in the ViewModel
        print('Sign in successful: ${userCredential.user?.email}'); // This is a log, not for UI
        _isLoading = false;
        notifyListeners();
        // Navigate to the calendar screen after successful login
        if (_context != null) {
           Navigator.of(_context!).pushReplacement(
            MaterialPageRoute(builder: (_) => const CalendarScreen()),
          );
        }
      } else {
        _isLoading = false;
        _errorMessage = AppStrings.signInFailed; // Using constant
        notifyListeners();
         if (_context != null) {
           ScaffoldMessenger.of(_context!).showSnackBar(
            const SnackBar(content: Text(AppStrings.signInFailed)), // Using constant
          );
        }
      }
    } catch (error) {
      // Handle the error
      _isLoading = false;
      _errorMessage = '${AppStrings.signInErrorPrefix}$error'; // Using constant
      notifyListeners();
       if (_context != null) {
         ScaffoldMessenger.of(_context!).showSnackBar(
          SnackBar(content: Text('${AppStrings.signInErrorPrefix}$error')), // Using constant
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
