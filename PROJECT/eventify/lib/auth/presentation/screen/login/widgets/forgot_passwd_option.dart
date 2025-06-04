// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:ui';

import 'package:eventify/auth/presentation/screen/login/widgets/custom_text_field.dart';
import 'package:eventify/auth/presentation/view_model/sign_in_view_model.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Constantes para valores numéricos y estilos en ForgotPasswordOption
const double kForgotPasswordDialogBlurSigma = 8.0;
const double kForgotPasswordDialogBarrierOpacity = 0.3;
const double kForgotPasswordDialogContentPaddingH = 24.0;
const double kForgotPasswordDialogContentPaddingV = 24.0;
const double kForgotPasswordDialogContentPaddingBottom = 0.0;
const double kForgotPasswordDialogActionsPaddingH = 8.0;
const double kForgotPasswordDialogActionsPaddingV = 8.0;

class ForgotPasswordOption extends StatelessWidget {
  const ForgotPasswordOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          final emailController = TextEditingController();
          final result = await showDialog<String>(
            context: context,
            barrierColor: Colors.black.withOpacity(
              kForgotPasswordDialogBarrierOpacity,
            ),
            builder:
                (context) => BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: kForgotPasswordDialogBlurSigma,
                    sigmaY: kForgotPasswordDialogBlurSigma,
                  ),
                  child: AlertDialog(
                    title: null,
                    contentPadding: EdgeInsets.fromLTRB(
                      kForgotPasswordDialogContentPaddingH,
                      kForgotPasswordDialogContentPaddingV,
                      kForgotPasswordDialogContentPaddingH,
                      kForgotPasswordDialogContentPaddingBottom,
                    ),
                    content: CustomTextField(
                      hintText: AppStrings.emailLabel(context),
                      controller: emailController,
                      textStyle: Theme.of(context).textTheme.bodyMedium!,
                    ),
                    actionsPadding: EdgeInsets.symmetric(
                      horizontal: kForgotPasswordDialogActionsPaddingH,
                      vertical: kForgotPasswordDialogActionsPaddingV,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          AppStrings.forgotPasswordDialogCancelButton(context),
                        ),
                      ),
                      TextButton(
                        onPressed:
                            () => Navigator.pop(
                              context,
                              emailController.text.trim(),
                            ),
                        child: Text(
                          AppStrings.forgotPasswordDialogSendButton(context),
                        ),
                      ),
                    ],
                  ),
                ),
          );
          if (result != null && result.isNotEmpty) {
            final signInViewModel = context.read<SignInViewModel>();
            await signInViewModel.sendPasswordResetEmail(result);
            if (signInViewModel.errorMessage == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppStrings.forgotPasswordDialogSuccess(context),
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(signInViewModel.errorMessage!)),
              );
            }
          }
        },
        child: Text(
          AppStrings.forgotPasswordOptionText(context),
          style: TextStyle(
            color: AppColors.textSecondary,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
