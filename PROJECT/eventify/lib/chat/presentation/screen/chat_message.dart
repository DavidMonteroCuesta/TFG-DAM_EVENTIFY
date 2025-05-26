import 'package:eventify/chat/presentation/screen/markdown_text.dart';
import 'package:eventify/common/theme/colors/colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventify/common/constants/app_strings.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    this.textColor,
  });

  final String text;
  final bool isUser;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    String userDisplayName = user?.displayName ?? AppStrings.chatUserDefaultName(context);
    final String firstLetter =
        userDisplayName.isNotEmpty ? userDisplayName[0].toUpperCase() : '';
    final String aiFirstLetters = AppStrings.chatAIAvatarLetters(context);
    final Color userColor =
        Colors.grey[700]!;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isUser) ...[
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: userColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: MarkdownText(
                  text: text,
                  baseStyle: TextStyles.plusJakartaSansBody1.copyWith(
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            CircleAvatar(
              backgroundColor: userColor,
              radius: 16,
              child: Text(
                firstLetter,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ] else ...[
            CircleAvatar(
              backgroundColor: AppColors.avatarBotBackground,
              radius: 16,
              child: Text(
                aiFirstLetters,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: AppColors.botMessageBackground,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: MarkdownText(
                  text: text,
                  baseStyle: TextStyles.urbanistBody1.copyWith(
                      color: Colors.black),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}