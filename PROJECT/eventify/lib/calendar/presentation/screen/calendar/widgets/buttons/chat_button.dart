import 'package:eventify/chat/presentation/screen/chat_screen.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

// Widget que muestra el botón de chat, permitiendo acceder a la pantalla de chat.
class ChatButton extends StatelessWidget {
  static const double _defaultSize = 40.0;
  static const double _iconSize = 24.0;
  static const double _iconPaddingDivisor = 2.0;

  final double size;

  const ChatButton({super.key, this.size = _defaultSize});

  void _navigateToChatScreen(BuildContext context) {
    Navigator.pushNamed(context, ChatScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    // Botón de chat que muestra el icono y navega a la pantalla de chat.
    return IconButton(
      onPressed: () => _navigateToChatScreen(context),
      icon: Icon(
        Icons.chat_bubble,
        color: AppColors.footerIconColor,
        size: _iconSize,
      ),
      iconSize: size,
      padding: EdgeInsets.all((size - _iconSize) / _iconPaddingDivisor),
      style: IconButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: Colors.transparent,
        highlightColor: AppColors.highlightColorWhite,
      ),
      tooltip: AppStrings.chatButtonTooltip(context),
    );
  }
}
