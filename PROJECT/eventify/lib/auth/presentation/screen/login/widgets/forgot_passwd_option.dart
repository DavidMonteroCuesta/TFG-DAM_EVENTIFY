import 'dart:ui';

import 'package:eventify/auth/presentation/screen/login/widgets/custom_text_field.dart';
import 'package:eventify/auth/presentation/view_model/sign_in_view_model.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/colors/app_colors.dart'; // Import AppColors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            barrierColor: Colors.black.withOpacity(0.3),
            builder:
                (context) => BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: AlertDialog(
                    title: null,
                    contentPadding: const EdgeInsets.fromLTRB(
                      24,
                      24,
                      24,
                      0,
                    ), // Reduce el padding inferior
                    content: CustomTextField(
                      hintText: AppStrings.emailLabel(context),
                      controller: emailController,
                      textStyle: Theme.of(context).textTheme.bodyMedium!,
                    ),
                    actionsPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ), // Reduce el padding de los botones
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
            color: AppColors.textSecondary, // Using AppColors
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
