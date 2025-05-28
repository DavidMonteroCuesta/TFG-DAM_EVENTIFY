import 'dart:math';

import 'package:eventify/auth/domain/use_cases/login_use_case.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventify/calendar/presentation/screen/calendar/calendar_screen.dart';
import 'package:eventify/common/constants/app_internal_constants.dart'; // Import AppInternalConstants
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui'; // Import for ImageFilter

import 'package:eventify/common/theme/colors/app_colors.dart';

class SignInViewModel extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  BuildContext? _context;

  SignInViewModel({required this.loginUseCase}) {
    // No need to check current user here. We do it in main.dart
  }

  // Method to initialize the view model with the context
  void initialize(BuildContext context) {
    _context = context;
  }

  // Method to sign in with Firebase, called from the UI
  Future<void> signInWithFirebase(
    BuildContext context,
    String email,
    String password,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    _context = context;
    notifyListeners();

    try {
      final UserCredential? userCredential = await loginUseCase.execute(
        email,
        password,
      );
      if (userCredential != null) {

        log('Sign in successful: ${userCredential.user?.email}' as num);
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
        _errorMessage = AppInternalConstants.signInFailed;
        notifyListeners();
        if (_context != null) {
          ScaffoldMessenger.of(_context!).showSnackBar(
            const SnackBar(content: Text(AppInternalConstants.signInFailed)),
          );
        }
      }
    } catch (error) {
      // Handle the error
      _isLoading = false;
      _errorMessage = '${AppInternalConstants.signInErrorPrefix}$error';
      notifyListeners();
      if (_context != null) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          SnackBar(
            content: Text('${AppInternalConstants.signInErrorPrefix}$error'),
          ),
        );
      }
    }
  }

  // Google Sign-In con contraseña adicional
  Future<User?> signInWithGoogleAndPassword(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final user = await GoogleSignIn().signIn();
      if (user == null) {
        _isLoading = false;
        notifyListeners();
        return null;
      }
      final googleAuth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        // Comprobar si el usuario existe en la base de datos (colección 'users')
        final firestore = FirebaseFirestore.instance;
        final userDoc =
            await firestore.collection('users').doc(firebaseUser.uid).get();
        if (!userDoc.exists) {
          // Usuario nuevo: pedir contraseña
          final password = await showDialog<String>(
            context: context,
            barrierColor: AppColors.profileHeaderBackground.withOpacity(0.80),
            builder: (context) {
              String pwd = '';
              String? errorText;
              return StatefulBuilder(
                builder: (context, setState) {
                  return Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: AlertDialog(
                          backgroundColor: AppColors.profileHeaderBackground
                              .withOpacity(0.92),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 340, // Más ancho
                                child: _PasswordFieldWithToggle(
                                  errorText: errorText,
                                  onChanged: (value) {
                                    pwd = value;
                                    if (errorText != null) {
                                      setState(() {
                                        errorText = null;
                                      });
                                    }
                                  },
                                ),
                              ),
                              if (errorText != null)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8.0,
                                    left: 4.0,
                                  ),
                                  child: Text(
                                    errorText!,
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                final validPwd = pwd
                                    .replaceAll('ñ', '')
                                    .replaceAll('Ñ', '');
                                if (validPwd.length < 8) {
                                  if (errorText == null) {
                                    setState(() {
                                      errorText =
                                          'La contraseña debe tener al menos 8 caracteres (sin contar la ñ).';
                                    });
                                  }
                                } else {
                                  Navigator.pop(context, pwd);
                                }
                              },
                              child: const Text(
                                'Guardar',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
          if (password != null && password.isNotEmpty) {
            await firebaseUser.updatePassword(password);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Contraseña guardada correctamente.'),
              ),
            );
          } else {
            // Si no define contraseña, cerrar sesión y mostrar error
            await FirebaseAuth.instance.signOut();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Debes definir una contraseña para continuar.'),
              ),
            );
            _isLoading = false;
            notifyListeners();
            return null;
          }
        }
        _isLoading = false;
        notifyListeners();
        return firebaseUser;
      }
      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error con Google: $e';
      notifyListeners();
      return null;
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

// Widget para el campo de contraseña con icono de mostrar/ocultar
class _PasswordFieldWithToggle extends StatefulWidget {
  final String? errorText;
  final ValueChanged<String> onChanged;
  const _PasswordFieldWithToggle({this.errorText, required this.onChanged});
  @override
  State<_PasswordFieldWithToggle> createState() =>
      _PasswordFieldWithToggleState();
}

class _PasswordFieldWithToggleState extends State<_PasswordFieldWithToggle> {
  bool _obscure = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _obscure,
      onChanged: widget.onChanged,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        filled: true,
        fillColor: AppColors.cardBackground,
        hintText: 'Contraseña',
        hintStyle: TextStyle(
          color:
              widget.errorText != null
                  ? Colors.redAccent
                  : AppColors.textSecondary,
          fontWeight: FontWeight.w400,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color:
                widget.errorText != null
                    ? Colors.redAccent
                    : AppColors.textSecondary.withOpacity(0.2),
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color:
                widget.errorText != null ? Colors.redAccent : AppColors.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        errorText: null, // Mostramos el error abajo
        suffixIcon: IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            color: AppColors.textSecondary,
          ),
          onPressed: () {
            setState(() {
              _obscure = !_obscure;
            });
          },
        ),
      ),
      cursorColor: AppColors.primary,
    );
  }
}
