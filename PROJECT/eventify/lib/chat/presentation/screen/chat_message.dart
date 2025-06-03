import 'package:eventify/chat/presentation/screen/markdown_text.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  // Widget que representa un mensaje en el chat, ya sea del usuario o del bot
  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    this.textColor,
  });

  final String text; // Texto del mensaje
  final bool isUser; // Indica si el mensaje es del usuario
  final Color? textColor;

  static const double _avatarRadius = 16.0;
  static const double _avatarFontSize = 14.0;
  static const double _bubbleBorderRadius = 8.0;
  static const double _bubblePadding = 12.0;
  static const double _horizontalSpacing = 8.0;
  static const double _verticalMargin = 8.0;
  static const double _horizontalMargin = 16.0;

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    String userDisplayName =
        user?.displayName ?? AppStrings.chatUserDefaultName(context);
    final String firstLetter =
        userDisplayName.isNotEmpty ? userDisplayName[0].toUpperCase() : '';
    final String aiFirstLetters = AppStrings.chatAIAvatarLetters(context);

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: _verticalMargin,
        horizontal: _horizontalMargin,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isUser) ...[
            // Mensaje del usuario
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(_bubblePadding),
                decoration: BoxDecoration(
                  color: AppColors.userMessageBubbleBackground,
                  borderRadius: BorderRadius.circular(_bubbleBorderRadius),
                ),
                child: MarkdownText(
                  text: text,
                  baseStyle: TextStyles.plusJakartaSansBody1.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: _horizontalSpacing),
            CircleAvatar(
              backgroundColor: AppColors.userMessageBubbleBackground,
              radius: _avatarRadius,
              child: Text(
                firstLetter,
                style: const TextStyle(
                  color: AppColors.avatarTextColor,
                  fontSize: _avatarFontSize,
                ),
              ),
            ),
          ] else ...[
            // Mensaje del bot
            CircleAvatar(
              backgroundColor: AppColors.avatarBotBackground,
              radius: _avatarRadius,
              child: Text(
                aiFirstLetters,
                style: const TextStyle(
                  color: AppColors.textOnLightBackground,
                  fontSize: _avatarFontSize,
                ),
              ),
            ),
            const SizedBox(width: _horizontalSpacing),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(_bubblePadding),
                decoration: BoxDecoration(
                  color: AppColors.botMessageBackground,
                  borderRadius: BorderRadius.circular(_bubbleBorderRadius),
                ),
                child: MarkdownText(
                  text: text,
                  baseStyle: TextStyles.urbanistBody1.copyWith(
                    color: AppColors.textOnLightBackground,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
