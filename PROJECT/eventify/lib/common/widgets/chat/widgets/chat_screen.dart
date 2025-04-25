import 'package:eventify/common/theme/colors/colors.dart';
import 'package:eventify/common/widgets/chat/widgets/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  final String _agentId = 'ag:b9c70aec:20250425:agente-de-eventify:5b623f1b'; // ID del agente

  @override
  void initState() {
    super.initState();
    // Mensaje inicial del bot al abrir el chat
    Future.delayed(Duration.zero, () {
      ChatMessage botGreeting = const ChatMessage(
        text: "¡Hola! Soy tu asistente de Eventify. ¿En qué puedo ayudarte hoy con tu agenda?",
        isUser: false,
      );
      setState(() {
        _messages.insert(0, botGreeting);
      });
      _scrollToBottom();
    });
  }

  void _handleSubmitted(String text) async {
    _messageController.clear();
    ChatMessage userMessage = ChatMessage(
      text: text,
      isUser: true,
    );
    setState(() {
      _messages.insert(0, userMessage);
    });
    _scrollToBottom();

    // Llamada a la API de Le-Chat
    final response = await _sendMessageToLeChat(text);

    ChatMessage botResponse = ChatMessage(
      text: response,
      isUser: false,
    );
    setState(() {
      _messages.insert(0, botResponse);
    });
    _scrollToBottom();
  }

  Future<String> _sendMessageToLeChat(String message) async {
    final url = Uri.parse('YOUR_LE_CHAT_API_ENDPOINT'); // Reemplaza con el endpoint de Le-Chat
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'YOUR_LE_CHAT_API_KEY', // Si Le-Chat requiere autenticación
    };
    final body = jsonEncode({
      'message': message, // Ajusta el nombre del campo según la API de Le-Chat
      'agent_id': _agentId,
      // ... otros parámetros que la API de Le-Chat pueda requerir
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // Ajusta cómo extraes la respuesta del bot según la estructura de la respuesta de Le-Chat
        return jsonResponse['response'] ?? 'Error al obtener respuesta';
      } else {
        print('Error al comunicarse con Le-Chat: ${response.statusCode}, body: ${response.body}');
        return 'Error al comunicarse con la IA.';
      }
    } catch (e) {
      print('Error de conexión con Le-Chat: $e');
      return 'No se pudo conectar con la IA.';
    }
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
            // ignore: deprecated_member_use
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