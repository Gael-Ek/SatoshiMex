import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class SatoshiButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;

  const SatoshiButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon, // El icono es opcional por si a veces quieres un botón sin flecha
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Para que ocupe todo el ancho
      height: 56, // Altura estándar para botones móviles
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryAmber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Bordes redondeados
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: AppColors
                    .charcoalBlack, // Letra oscura para contrastar con el naranja
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, color: AppColors.charcoalBlack),
            ],
          ],
        ),
      ),
    );
  }
}
