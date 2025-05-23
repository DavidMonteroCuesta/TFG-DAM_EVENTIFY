import 'package:eventify/chat/presentation/view_model/chat_view_model.dart';
import 'package:eventify/common/animations/ani_shining_text.dart';
import 'package:eventify/common/theme/colors/colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Color _cardBackgroundColor = const Color(0xFF1F1F1F);
  final Color _headerBackgroundColor = Colors.grey[800]!;
  final Color _inputBackgroundColor = const Color(0xFF1F1F1F);

  @override
  void initState() {
    super.initState();
    // Accede al ViewModel y añade el saludo inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
      if (chatViewModel.messages.isEmpty) { // Solo si no hay mensajes aún
        chatViewModel.addInitialBotGreeting(
          "Hello! I am your Eventify assistant. How can I help you with your schedule today?",
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
    final chatViewModel = Provider.of<ChatViewModel>(context); // Escucha el ViewModel para el estado de carga
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
        // MODIFIED: Adjusted padding to push content to the top of the input box
        // Reduced top padding to make elements appear higher.
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 35.0), // Left, Top, Right, Bottom
        child: Row(
          // Align children to the start (top) of the row
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                onSubmitted: chatViewModel.isLoading ? null : _handleSubmitted, // Deshabilita la entrada si la IA está cargando
                style: TextStyles.plusJakartaSansBody1,
                decoration: InputDecoration(
                  hintText: chatViewModel.isLoading ? 'Thinking...' : 'Escribe un mensaje...', // Muestra "Thinking..." cuando carga
                  hintStyle: TextStyles
                      .plusJakartaSansSubtitle2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: AppColors.secondary, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide.none,
                  ),
                  // Content padding for the TextField itself
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  filled: true,
                  fillColor:
                      _inputBackgroundColor,
                ),
                maxLines: null,
                minLines: 1, // Cambiado a 1 para mejor experiencia de usuario
              ),
            ),
            IconButton(
              icon: chatViewModel.isLoading
                  ? const CircularProgressIndicator(color: AppColors.textPrimary) // Indicador de carga en el botón
                  : const Icon(Icons.send, color: AppColors.textPrimary),
              onPressed: chatViewModel.isLoading
                  ? null // Deshabilita el botón si la IA está cargando
                  : () => _handleSubmitted(_messageController.text),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usa Consumer para reconstruir solo la lista de mensajes cuando cambie
    return Scaffold(
      appBar: AppBar(
        title: ShiningTextAnimation(
          text: 'Chat with Eventify',
          style: TextStyles.urbanistBody1,
        ),
        titleTextStyle: TextStyles.urbanistBody1,
        backgroundColor: _headerBackgroundColor,
        foregroundColor:
            AppColors.outline,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: kToolbarHeight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.outline),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatViewModel>(
              builder: (context, chatViewModel, child) {
                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                  itemCount: chatViewModel.messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return chatViewModel.messages[index];
                  },
                );
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
