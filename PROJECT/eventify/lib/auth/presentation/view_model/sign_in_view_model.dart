import 'dart:ui'; // Import for ImageFilter

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/auth/domain/use_cases/login_use_case.dart';
import 'package:eventify/auth/domain/use_cases/send_password_reset_email_use_case.dart';
import 'package:eventify/calendar/presentation/screen/calendar/calendar_screen.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInViewModel extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  BuildContext? _context;

  SignInViewModel({
    required this.loginUseCase,
    required this.sendPasswordResetEmailUseCase,
  }) {
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

    // Validación de campos vacíos
    if (email.isEmpty || password.isEmpty) {
      _isLoading = false;
      _errorMessage = AppStrings.signInCredentialsFailed(context);
      notifyListeners();
      if (_context != null) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          SnackBar(content: Text(AppStrings.signInCredentialsFailed(context))),
        );
      }
      return;
    }

    try {
      final UserCredential? userCredential = await loginUseCase.execute(
        email,
        password,
      );
      if (userCredential != null) {
        _isLoading = false;
        notifyListeners();
        if (_context != null) {
          Navigator.of(_context!).pushReplacement(
            MaterialPageRoute(builder: (_) => const CalendarScreen()),
          );
        }
      } else {
        _isLoading = false;
        _errorMessage = AppStrings.signInCredentialsFailed(context);
        notifyListeners();
        if (_context != null) {
          ScaffoldMessenger.of(_context!).showSnackBar(
            SnackBar(
              content: Text(AppStrings.signInCredentialsFailed(context)),
            ),
          );
        }
      }
    } catch (error) {
      // Mostrar siempre un mensaje genérico al usuario
      _isLoading = false;
      _errorMessage = AppStrings.signInFailed(context);
      notifyListeners();
      if (_context != null) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          SnackBar(content: Text(AppStrings.signInFailed(context))),
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
                                          AppStrings.passwordRequirementsNotMet(
                                            context,
                                          );
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
              SnackBar(content: Text(AppStrings.passwordSaved(context))),
            );
          } else {
            // Si no define contraseña, cerrar sesión y mostrar error
            await FirebaseAuth.instance.signOut();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppStrings.passwordRequired(context))),
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
      _errorMessage = AppStrings.signInFailed(context);
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      _errorMessage = AppStrings.signInFailed(context);
      notifyListeners();
      return null;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await sendPasswordResetEmailUseCase.execute(email);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      if (_context != null) {
        _errorMessage = AppStrings.passwordResetError(_context!);
      } else {
        _errorMessage = 'Error al enviar el correo de recuperación.';
      }
      notifyListeners();
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
        hintText: AppStrings.signInPasswordHint(context),
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
