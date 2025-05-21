import 'package:eventify/chat/domain/use_cases/send_message_use_case.dart';
import 'package:eventify/chat/presentation/screen/chat_message.dart';
import 'package:flutter/material.dart';

class ChatViewModel extends ChangeNotifier {
  final SendMessageUseCase _sendMessageUseCase;
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  ChatViewModel({required SendMessageUseCase sendMessageUseCase})
      : _sendMessageUseCase = sendMessageUseCase;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) {
      return;
    }

    _messages.insert(0, ChatMessage(text: text, isUser: true));
    _setLoading(true);

    try {
      final String aiResponse = await _sendMessageUseCase.execute(text);

      _messages.insert(0, ChatMessage(text: aiResponse, isUser: false));
    } catch (e) {
      _messages.insert(0, ChatMessage(text: 'Error: ${e.toString()}', isUser: false));
    } finally {
      _setLoading(false);
    }
  }

  void addInitialBotGreeting(String greeting) {
    _messages.insert(0, ChatMessage(text: greeting, isUser: false));
    notifyListeners();
  }
}
