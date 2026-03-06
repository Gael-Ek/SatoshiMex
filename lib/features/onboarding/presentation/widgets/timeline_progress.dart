import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class TimelineProgress extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool completed;
  final bool isLast;

  const TimelineProgress({
    super.key,
    required this.title,
    required this.subtitle,
    this.completed = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    const primary = AppColors.primaryAmber;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// COLUMNA IZQUIERDA (ICONO + LINEA)
        Column(
          children: [
            /// CIRCULO
            Container(
              height: completed ? 40 : 48,
              width: completed ? 40 : 48,
              decoration: BoxDecoration(
                color: completed ? primary.withValues(alpha: .2) : primary,
                shape: BoxShape.circle,
                border: completed
                    ? Border.all(color: primary.withValues(alpha: .3))
                    : null,
              ),
              child: Icon(
                completed ? Icons.check_circle : Icons.lock,
                color: completed ? primary : Colors.black,
                size: completed ? 20 : 28,
              ),
            ),

            /// LINEA
            if (!isLast)
              Container(
                width: 4,
                height: 48,
                color: primary.withValues(alpha: .3),
              ),
          ],
        ),

        const SizedBox(width: 16),

        /// TEXTO
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: completed ? 4 : 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: completed ? 16 : 18,
                    fontWeight: completed ? FontWeight.w600 : FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: completed
                        ? primary.withValues(alpha: .7)
                        : Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
