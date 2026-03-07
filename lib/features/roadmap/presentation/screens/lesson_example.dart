import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class LessonExample extends StatelessWidget {
  final String content;
  final String? imageUrl;
  final String? title; // Por defecto "Ejemplo Práctico"
  final String? subtitle;

  const LessonExample({
    super.key,
    required this.content,
    this.imageUrl,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryAmber.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryAmber.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera del Ejemplo
          Row(
            children: [
              const Icon(
                Icons.lightbulb_rounded,
                color: AppColors.primaryAmber,
                size: 26,
              ),
              const SizedBox(width: 10),
              Text(
                "Ejemplo Práctico",
                style: const TextStyle(
                  color: AppColors.primaryAmber,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          if (imageUrl != null || subtitle != null || content.isNotEmpty)
            const Divider(
              height: 32,
              color: AppColors.primaryAmber,
              thickness: 0.5,
            ),

          // Imagen opcional dentro del ejemplo
          if (imageUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl!,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Subtítulo opcional
          if (subtitle != null) ...[
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Contenido principal
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
