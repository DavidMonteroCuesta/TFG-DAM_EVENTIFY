import 'package:eventify/common/theme/colors/colors.dart';
import 'package:eventify/common/widgets/chat/widgets/chat_message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  void _handleSubmitted(String text) {
    _messageController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      isUser: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    _scrollToBottom();

    // Simulación de respuesta del bot (sin cambios aquí)
    Future.delayed(const Duration(milliseconds: 800), () {
      ChatMessage botResponse = ChatMessage(
        text: "Hola, he recibido tu mensaje: '$text'. ¿En qué puedo ayudarte con tu agenda hoy?",
        isUser: false,
      );
      setState(() {
        _messages.insert(0, botResponse);
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Widget _buildTextComposer() {
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
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                onSubmitted: _handleSubmitted,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Escribe un mensaje...',
                  hintStyle: TextStyle(color: AppColors.hintTextColor),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: AppColors.textPrimary),
              onPressed: () => _handleSubmitted(_messageController.text),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat con Eventify'), // Cambiado el título
        backgroundColor: AppColors.cardBackground,
        elevation: 1,
        leading: IconButton( // Añadido el botón de retroceso
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navega de vuelta a la pantalla anterior
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return _messages[index];
              },
            ),
          ),
          const Divider(height: 1.0, color: AppColors.dividerColor),
          _buildTextComposer(),
        ],
      ),
    );
  }
}

