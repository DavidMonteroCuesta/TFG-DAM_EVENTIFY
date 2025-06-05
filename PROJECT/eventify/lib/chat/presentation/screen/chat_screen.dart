// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:eventify/chat/presentation/view_model/chat_view_model.dart';
import 'package:eventify/common/animations/ani_shining_text.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/common/constants/app_routes.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = AppRoutes.chat;
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController =
      TextEditingController(); // Controlador para el input de mensajes
  final ScrollController _scrollController =
      ScrollController(); // Controlador para el scroll del chat

  static const double _boxShadowOffsetX = 0.0;
  static const double _boxShadowOffsetY = -1.0;
  static const double _boxShadowBlurRadius = 2.0;
  static const double _boxShadowOpacity = 0.1;
  static const double _composerPaddingLeft = 8.0;
  static const double _composerPaddingTop = 8.0;
  static const double _composerPaddingRight = 8.0;
  static const double _composerPaddingBottom = 35.0;
  static const double _inputBorderRadius = 10.0;
  static const double _inputFocusedBorderWidth = 1.5;
  static const double _inputContentPaddingH = 16.0;
  static const double _inputContentPaddingV = 16.0;
  static const double _dividerHeight = 1.0;
  static const double _listPaddingH = 8.0;
  static const double _listPaddingV = 16.0;
  static const double _headerBlurSigma = 18.0;
  static const double _headerOpacity = 0.2;
  static const double _headerHeightFactor = 1;
  static const double _headerIconBottomFactor = 0.1;
  static const double _headerTitleBottomFactor = 0.2;
  static const double _positionedLeft = 0.0;
  static const double _positionedRight = 0.0;
  static const double _borderRadiusZero = 0.0;

  @override
  void initState() {
    super.initState();
    // Al iniciar, añade el saludo inicial del bot si no hay mensajes y hace scroll al fondo
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

  // Maneja el envío de mensajes del usuario
  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty) {
      return;
    }
    final chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
    _messageController.clear();
    await chatViewModel.sendMessage(text);
    _scrollToBottom();
  }

  // Hace scroll al fondo del chat
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

  // Construye el input de texto y el botón de enviar
  Widget _buildTextComposer() {
    final chatViewModel = Provider.of<ChatViewModel>(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            offset: const Offset(_boxShadowOffsetX, _boxShadowOffsetY),
            blurRadius: _boxShadowBlurRadius,
            color: Colors.black.withOpacity(_boxShadowOpacity),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          _composerPaddingLeft,
          _composerPaddingTop,
          _composerPaddingRight,
          _composerPaddingBottom,
        ),
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
                    borderRadius: BorderRadius.circular(_inputBorderRadius),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_inputBorderRadius),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: _inputFocusedBorderWidth,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_inputBorderRadius),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: _inputContentPaddingH,
                    vertical: _inputContentPaddingV,
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
    const double headerHeight = kToolbarHeight * _headerHeightFactor;
    return SafeArea(
      child: Scaffold(
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
                          horizontal: _listPaddingH,
                          vertical: _listPaddingV,
                        ),
                        itemCount: chatViewModel.messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          return chatViewModel.messages[index];
                        },
                      );
                    },
                  ),
                ),
                const Divider(
                  height: _dividerHeight,
                  color: AppColors.dividerColor,
                ),
                _buildTextComposer(),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(_borderRadiusZero),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: _headerBlurSigma,
                  sigmaY: _headerBlurSigma,
                ),
                child: Container(
                  width: double.infinity,
                  height: headerHeight,
                  color: AppColors.headerBackground.withOpacity(_headerOpacity),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: headerHeight * _headerTitleBottomFactor,
                        left: _positionedLeft,
                        right: _positionedRight,
                        child: Center(
                          child: ShiningTextAnimation(
                            text:
                                AppStrings.chatScreenTitle(
                                  context,
                                ).toUpperCase(),
                            style: TextStyles.urbanistBody1,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: headerHeight * _headerIconBottomFactor,
                        left: _positionedLeft,
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
      ),
    );
  }
}
