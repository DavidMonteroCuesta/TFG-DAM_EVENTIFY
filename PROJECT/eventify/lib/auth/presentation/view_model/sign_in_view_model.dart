// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/auth/domain/use_cases/login_use_case.dart';
import 'package:eventify/auth/domain/use_cases/send_password_reset_email_use_case.dart';
import 'package:eventify/calendar/presentation/screen/calendar/calendar_screen.dart';
import 'package:eventify/common/constants/app_firestore_fields.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

const double kDialogBlurSigma = 10.0;
const double kDialogBorderRadius = 16.0;
const double kDialogBackgroundOpacity = 0.92;
const double kDialogBarrierOpacity = 0.80;
const double kDialogWidth = 340.0;
const double kPasswordErrorFontSize = 13.0;
const int kPasswordMinLength = 8;
const double kInputBorderRadius = 12.0;
const double kInputBorderWidth = 1.2;
const double kInputBorderWidthFocused = 1.5;
const double kInputVerticalPadding = 16.0;
const double kInputHorizontalPadding = 16.0;
const double kPasswordFieldFontSize = 16.0;
const double kPasswordFieldErrorBorderWidth = 1.5;
const double kPasswordFieldPaddingTop = 8.0;
const double kPasswordFieldPaddingLeft = 4.0;
const double kPasswordFieldTextSecondaryOpacity = 0.2;

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
    // No es necesario comprobar el usuario actual aquí
  }

  void initialize(BuildContext context) {
    _context = context;
  }

  Future<void> signInWithFirebase(
    BuildContext context,
    String email,
    String password,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    _context = context;
    notifyListeners();

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
      final user = await _signInWithGoogle();
      if (user == null) {
        _isLoading = false;
        notifyListeners();
        return null;
      }
      final firebaseUser = await _signInWithGoogleCredential(user);
      if (firebaseUser != null) {
        final isNewUser = await _isNewUser(firebaseUser);
        if (isNewUser) {
          final password = await _promptForPassword(context);
          if (password != null && password.isNotEmpty) {
            await firebaseUser.updatePassword(password);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppStrings.passwordSaved(context))),
            );
          } else {
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

  Future<GoogleSignInAccount?> _signInWithGoogle() async {
    return await GoogleSignIn().signIn();
  }

  Future<User?> _signInWithGoogleCredential(GoogleSignInAccount user) async {
    final googleAuth = await user.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    return userCredential.user;
  }

  Future<bool> _isNewUser(User firebaseUser) async {
    final firestore = FirebaseFirestore.instance;
    final userDoc =
        await firestore
            .collection(AppFirestoreFields.users)
            .doc(firebaseUser.uid)
            .get();
    return !userDoc.exists;
  }

  Future<String?> _promptForPassword(BuildContext context) async {
    String pwd = '';
    String? errorText;
    return await showDialog<String>(
      context: context,
      barrierColor: AppColors.profileHeaderBackground.withOpacity(
        kDialogBarrierOpacity,
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kDialogBorderRadius),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: kDialogBlurSigma,
                    sigmaY: kDialogBlurSigma,
                  ),
                  child: AlertDialog(
                    backgroundColor: AppColors.profileHeaderBackground
                        .withOpacity(kDialogBackgroundOpacity),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: kDialogWidth,
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
                            padding: EdgeInsets.only(
                              top: kPasswordFieldPaddingTop,
                              left: kPasswordFieldPaddingLeft,
                            ),
                            child: Text(
                              errorText!,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: kPasswordErrorFontSize,
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
                          if (validPwd.length < kPasswordMinLength) {
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
                        child: Text(
                          AppStrings.savePassword(context),
                          style: const TextStyle(color: Colors.white),
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
        fontSize: kPasswordFieldFontSize,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: kInputVerticalPadding,
          horizontal: kInputHorizontalPadding,
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
          borderRadius: BorderRadius.circular(kInputBorderRadius),
          borderSide: BorderSide(
            color:
                widget.errorText != null
                    ? Colors.redAccent
                    : AppColors.textSecondary.withOpacity(
                      kPasswordFieldTextSecondaryOpacity,
                    ),
            width: kInputBorderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kInputBorderRadius),
          borderSide: BorderSide(
            color:
                widget.errorText != null ? Colors.redAccent : AppColors.primary,
            width: kInputBorderWidthFocused,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kInputBorderRadius),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: kPasswordFieldErrorBorderWidth,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kInputBorderRadius),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: kPasswordFieldErrorBorderWidth,
          ),
        ),
        errorText: null,
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
