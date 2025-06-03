// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:eventify/chat/presentation/view_model/chat_view_model.dart';
import 'package:eventify/common/animations/ani_shining_text.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/common/constants/app_routes.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = AppRoutes.chat;

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
      if (chatViewModel.messages.isEmpty) {
        chatViewModel.addInitialBotGreeting(
          AppStrings.chatInitialBotGreeting(context),
        );
      }
      _scrollToBottom();
    });
  }

  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty) {
      return;
    }
    final chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
    _messageController.clear();
    await chatViewModel.sendMessage(text);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Widget _buildTextComposer() {
    final chatViewModel = Provider.of<ChatViewModel>(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            blurRadius: 2,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 35.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                onSubmitted: chatViewModel.isLoading ? null : _handleSubmitted,
                style: TextStyles.plusJakartaSansBody1,
                decoration: InputDecoration(
                  hintText:
                      chatViewModel.isLoading
                          ? AppInternalConstants.chatThinkingHint
                          : AppStrings.chatInputHint(context),
                  hintStyle: TextStyles.plusJakartaSansSubtitle2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  filled: true,
                  fillColor: AppColors.inputFillColor,
                ),
                maxLines: null,
                minLines: 1,
              ),
            ),
            IconButton(
              icon:
                  chatViewModel.isLoading
                      ? const CircularProgressIndicator(
                        color: AppColors.textPrimary,
                      )
                      : const Icon(Icons.send, color: AppColors.textPrimary),
              onPressed:
                  chatViewModel.isLoading
                      ? null
                      : () => _handleSubmitted(_messageController.text),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double headerHeight = kToolbarHeight * 1.6;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: headerHeight),
              Expanded(
                child: Consumer<ChatViewModel>(
                  builder: (context, chatViewModel, child) {
                    return ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 16.0,
                      ),
                      itemCount: chatViewModel.messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return chatViewModel.messages[index];
                      },
                    );
                  },
                ),
              ),
              const Divider(height: 1.0, color: AppColors.dividerColor),
              _buildTextComposer(),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.zero,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                width: double.infinity,
                height: headerHeight,
                color: AppColors.headerBackground.withOpacity(0.2),
                child: Stack(
                  children: [
                    Positioned(
                      bottom:
                          headerHeight * 0.2,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: ShiningTextAnimation(
                          text: AppStrings.chatScreenTitle(context).toUpperCase(),
                          style: TextStyles.urbanistBody1,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: headerHeight * 0.1,
                      left: 0,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.outline,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
