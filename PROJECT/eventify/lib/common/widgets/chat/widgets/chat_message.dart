import 'package:eventify/common/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
  });

  final String text;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundColor: AppColors.avatarBotBackground,
                child: const Text('AI', style: TextStyle(color: AppColors.avatarTextColor)),
              ),
            ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: isUser ? AppColors.userMessageBackground : AppColors.botMessageBackground,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                text,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            ),
          ),
          if (isUser)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                backgroundColor: AppColors.textPrimary,
                radius: 12,
                child: const Text(
                  'Tú',
                  style: TextStyle(color: Colors.black, fontSize: 10),
                ),
              ),
            ),
        ],
      ),
    );
  }
}