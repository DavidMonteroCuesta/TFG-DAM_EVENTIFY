import 'package:eventify/common/animations/ani_shining_text.dart';
import 'package:eventify/common/theme/colors/colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
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
  final Color _cardBackgroundColor = const Color(0xFF1F1F1F);
  final Color _headerBackgroundColor = Colors.grey[800]!;
  final Color _inputBackgroundColor = const Color(0xFF1F1F1F);

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
                style: TextStyles.plusJakartaSansBody1,
                decoration: InputDecoration(
                  hintText: 'Escribe un mensaje...',
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  filled: true,
                  fillColor:
                      _inputBackgroundColor,
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
