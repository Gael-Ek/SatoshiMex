import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class LessonExplanation extends StatelessWidget {
  final String content;
  final String? imageUrl;
  final String? title;
  final String? subtitle;

  const LessonExplanation({
    super.key,
    required this.content,
    this.imageUrl,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (imageUrl != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              imageUrl!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                color: Colors.grey[200],
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
        if (title != null) ...[
          Text(
            title!,
            style: const TextStyle(
              color: AppColors.primaryAmber,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
        ],
        if (subtitle != null) ...[
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
        ],
        Text(
          content,
          style: const TextStyle(fontSize: 17, height: 1.6, color: Colors.grey),
        ),
      ],
    );
  }
}
