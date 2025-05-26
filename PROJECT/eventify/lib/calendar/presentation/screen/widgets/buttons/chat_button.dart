import 'package:eventify/common/theme/colors/colors.dart';
import 'package:eventify/chat/presentation/screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:eventify/common/constants/app_strings.dart'; // Import the AppStrings constants

class ChatButton extends StatelessWidget {
  final double size;

  const ChatButton({
    super.key,
    this.size = 40.0,
  });

  void _navigateToChatScreen(BuildContext context) {
    Navigator.pushNamed(context, ChatScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _navigateToChatScreen(context),
      icon: Icon(
        Icons.chat_bubble,
        color: AppColors.footerIconColor,
        size: 24.0,
      ),
      iconSize: size,
      padding: EdgeInsets.all((40 - 24) / 2),
      style: IconButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: Colors.transparent,
        // ignore: deprecated_member_use
        highlightColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.4),
      ),
      tooltip: AppStrings.chatButtonTooltip(context), // Using constant
    );
  }
}