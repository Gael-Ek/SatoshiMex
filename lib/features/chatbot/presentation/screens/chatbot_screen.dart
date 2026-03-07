import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/features/chatbot/presentation/widgets/chatbot_widgets.dart';

class MessageModel {
  final String text;
  final bool isUser;
  final bool isError;

  MessageModel({
    required this.text,
    required this.isUser,
    this.isError = false,
  });
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  final List<MessageModel> _messages = [
    MessageModel(
      text:
          '¿En qué puedo ayudarte hoy con respecto a tus inversiones o al mercado actual?',
      isUser: false,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    String userMessage = _messageController.text.trim();
    String userName = "Usuario";

    setState(() {
      _messages.add(MessageModel(text: userMessage, isUser: true));
      _isLoading = true;
      _messageController.clear();
    });

    _scrollToBottom();

    try {
      final url = Uri.parse(
        'https://brittany-pasquilic-adria.ngrok-free.dev/webhook/chat',
      );

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "ngrok-skip-browser-warning": "true",
        },
        body: jsonEncode({"message": userMessage, "usuario": userName}),
      );

      if (response.statusCode == 200) {
        String aiReply = response.body;
        if (mounted) {
          setState(() {
            _isLoading = false;
            _messages.add(MessageModel(text: aiReply, isUser: false));
          });
          _scrollToBottom();
        }
      } else {
        _handleError();
      }
    } catch (e) {
      _handleError();
    }
  }

  void _handleError() {
    if (mounted) {
      setState(() {
        _isLoading = false;
        _messages.add(
          MessageModel(
            text:
                "Lo siento, ToshiBot no está disponible en este momento debido a un problema de conexión. 🔌",
            isUser: false,
            isError: true,
          ),
        );
      });
      _scrollToBottom();
    }
  }

  void _onSuggestionTap(String text) {
    _messageController.text = text;
    _sendMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueDark,
      appBar: const ChatbotAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 24.0,
              ),
              children: [
                const BotHeader(),
                const SizedBox(height: 32),

                if (_messages.length == 1) ...[
                  const Text(
                    'SUGERENCIAS',
                    style: TextStyle(
                      color: AppColors.primaryAmber,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SuggestionCard(
                    text: '¿Qué es Bitcoin?',
                    onTap: () => _onSuggestionTap('¿Qué es Bitcoin?'),
                  ),
                  SuggestionCard(
                    text: '¿Cómo funciona Ethereum?',
                    onTap: () => _onSuggestionTap('¿Cómo funciona Ethereum?'),
                  ),
                  SuggestionCard(
                    text: 'Explícame el Halving',
                    onTap: () => _onSuggestionTap('Explícame el Halving'),
                  ),
                  const SizedBox(height: 24),
                ],

                for (var message in _messages)
                  message.isUser
                      ? UserMessageBubble(text: message.text)
                      : BotMessageBubble(
                          text: message.text,
                          isError: message.isError,
                          isTyping: false,
                        ),

                // ✅ AQUÍ ESTÁN LOS 3 PUNTITOS CUANDO LA IA ESTÁ PENSANDO
                if (_isLoading)
                  const BotMessageBubble(text: "", isTyping: true),
              ],
            ),
          ),
          ChatInputArea(
            controller: _messageController,
            onSend: _sendMessage,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
