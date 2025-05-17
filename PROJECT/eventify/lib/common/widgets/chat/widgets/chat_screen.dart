import 'package:eventify/common/theme/colors/colors.dart';
import 'package:eventify/common/widgets/chat/widgets/chat_message.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

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
  final Color _cardBackgroundColor =
      const Color(0xFF1F1F1F);
  final Color _headerBackgroundColor =
      Colors.grey[800]!;
  final Color _inputBackgroundColor =
      const Color(0xFF1F1F1F);

  //final String _agentId = 'ag:b9c70aec:20250425:agente-de-eventify:5b623f1b';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      const ChatMessage botGreeting = ChatMessage(
        text:
            "Hello! I am your Eventify assistant. How can I help you with your schedule today?",
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
    // final response = await _sendMessageToLeChat(text);

    // Simular una respuesta
    const String simulatedResponse =
        "This feature is not yet implemented.  Please check back later!";
    ChatMessage botResponse = ChatMessage(
      text: simulatedResponse,
      isUser: false,
    );
    setState(() {
      _messages.insert(0, botResponse);
    });
    _scrollToBottom();
  }

  // Future<String> _sendMessageToLeChat(String message) async {
  //   final url = Uri.parse('YOUR_LE_CHAT_API_ENDPOINT'); // Reemplaza con el endpoint de Le-Chat
  //   final headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'YOUR_LE_CHAT_API_KEY', // Si Le-Chat requiere autenticación
  //   };
  //   final body = jsonEncode({
  //     'message': message, // Ajusta el nombre del campo según la API de Le-Chat
  //     'agent_id': _agentId,
  //     // ... otros parámetros que la API de Le-Chat pueda requerir
  //   });

  //   try {
  //     final response = await http.post(url, headers: headers, body: body);

  //     if (response.statusCode == 200) {
  //         final jsonResponse = jsonDecode(response.body);
  //         return jsonResponse['response'] ?? 'Error al obtener respuesta';
  //     } else {
  //       print('Error al comunicarse con Le-Chat: ${response.statusCode}, body: ${response.body}');
  //       return 'Error al comunicarse con la IA.';
  //     }
  //   } catch (e) {
  //     print('Error de conexión con Le-Chat: $e');
  //     return 'No se pudo conectar con la IA.';
  //   }
  // }

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
        color: _cardBackgroundColor,
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
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontFamily: GoogleFonts.urbanist().fontFamily), // Apply font
                decoration: InputDecoration(
                  hintText: 'Escribe un mensaje...',
                  hintStyle: TextStyle(
                      color: AppColors.hintTextColor,
                      fontFamily: GoogleFonts
                          .urbanist()
                          .fontFamily), // Apply font and hint color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: AppColors.secondary, width: 1.5), // Focused border color
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide.none, // No border when not focused/enabled
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  filled: true,
                  fillColor:
                      _inputBackgroundColor, // Background color for the input
                ),
                maxLines: null,
                minLines: 3,
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
        title: const Text('Chat with Eventify'),
        titleTextStyle: TextStyle(
            fontFamily: GoogleFonts.urbanist().fontFamily,
            fontSize: 20,
            fontWeight: FontWeight.w600), // Apply font and style
        backgroundColor: _headerBackgroundColor, // Use header color
        foregroundColor:
            AppColors.outline, //  consistent with AddEventScreen
        elevation: 0, // Remove shadow
        centerTitle: true,
        toolbarHeight: kToolbarHeight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.outline),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.black, // Keep the black background
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return _messages[index];
              },
            ),
          ),
          const Divider(
            height: 1.0,
            color: AppColors.dividerColor,
          ),
          _buildTextComposer(),
        ],
      ),
    );
  }
}

