import 'package:eventify/chat/domain/use_cases/send_message_use_case.dart';
import 'package:eventify/chat/presentation/screen/chat_message.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:flutter/material.dart';

class ChatViewModel extends ChangeNotifier {
  static const int _userMessageIndex = 0;

  final SendMessageUseCase _sendMessageUseCase;
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  // Constructor con inyección del caso de uso para enviar mensajes
  ChatViewModel({required SendMessageUseCase sendMessageUseCase})
    : _sendMessageUseCase = sendMessageUseCase;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Envía un mensaje, añade el mensaje del usuario y la respuesta de la IA
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) {
      return;
    }

    _messages.insert(_userMessageIndex, ChatMessage(text: text, isUser: true));
    _setLoading(true);

    try {
      final String aiResponse = await _sendMessageUseCase.execute(text);

      _messages.insert(
        _userMessageIndex,
        ChatMessage(text: aiResponse, isUser: false),
      );
    } catch (e) {
      _messages.insert(
        _userMessageIndex,
        ChatMessage(
          text: '${AppInternalConstants.chatErrorPrefix}${e.toString()}',
          isUser: false,
        ),
      );
    } finally {
      _setLoading(false);
    }
  }

  // Añade el mensaje inicial del bot al chat
  void addInitialBotGreeting(String greeting) {
    _messages.insert(
      _userMessageIndex,
      ChatMessage(text: greeting, isUser: false),
    );
    notifyListeners();
  }
}
