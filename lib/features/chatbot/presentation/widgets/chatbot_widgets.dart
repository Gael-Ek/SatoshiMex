import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

// --- 1. APP BAR PERSONALIZADO ---
class ChatbotAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatbotAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'ToshiBot AI',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'ONLINE',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// --- 2. CABECERA DEL BOT ---
class BotHeader extends StatelessWidget {
  const BotHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryAmber.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primaryAmber.withValues(alpha: 0.3),
            ),
          ),
          child: const Icon(
            Icons.smart_toy_rounded,
            color: AppColors.primaryAmber,
            size: 40,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '¡Hola! Soy ToshiBot',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tu guía experto en el ecosistema\nSatoshiMX y el mundo cripto.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

// --- 3. TARJETA DE SUGERENCIA ---
class SuggestionCard extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const SuggestionCard({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.deepNavy,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 18.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primaryAmber,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- 4. BURBUJA DE MENSAJE DEL BOT (UNIFICADA) ---
class BotMessageBubble extends StatelessWidget {
  final String text;
  final bool isError;
  final bool isTyping;

  const BotMessageBubble({
    super.key,
    required this.text,
    this.isError = false,
    this.isTyping = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isError
                  ? Colors.red.withValues(alpha: 0.2)
                  : AppColors.primaryAmber.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isError ? Icons.error_outline : Icons.smart_toy_rounded,
              color: isError ? Colors.red : AppColors.primaryAmber,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF16202B),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                  topLeft: Radius.circular(4),
                ),
                border: isError
                    ? Border.all(color: Colors.red.withValues(alpha: 0.5))
                    : null,
              ),
              child: isTyping
                  ? const Text(
                      "...", // Los tres puntos literales
                      style: TextStyle(
                        color: AppColors
                            .primaryAmber, // Mantiene el color de tu marca
                        fontSize: 24, // Tamaño adecuado para los puntos
                        fontWeight: FontWeight.bold,
                        height:
                            0.5, // Ajuste vertical para que no ocupe espacio extra
                        letterSpacing: 2, // Espaciado entre los puntos
                      ),
                    )
                  : MarkdownBody(
                      data: text,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.4,
                        ),
                        strong: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- 5. INDICADOR DE CARGA ---
class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});
  @override
  Widget build(BuildContext context) =>
      const Text("...", style: TextStyle(color: Colors.white, fontSize: 16));
}

// --- 6. ÁREA DE ENTRADA DE TEXTO ---
class ChatInputArea extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isLoading;

  const ChatInputArea({
    super.key,
    required this.controller,
    required this.onSend,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 24),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Escribe un mensaje...',
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                filled: true,
                fillColor: AppColors.deepNavy,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryAmber,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: isLoading ? null : onSend,
            ),
          ),
        ],
      ),
    );
  }
}

// --- 7. BURBUJA DE MENSAJE DEL USUARIO ---
class UserMessageBubble extends StatelessWidget {
  final String text;

  const UserMessageBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(left: 40),
              decoration: BoxDecoration(
                color: AppColors.deepNavy,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                  topRight: Radius.circular(4),
                ),
                border: Border.all(color: AppColors.slateBlueGray),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.deepNavy,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.slateBlueGray),
            ),
            child: const Icon(
              Icons.person,
              color: AppColors.primaryAmber,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
