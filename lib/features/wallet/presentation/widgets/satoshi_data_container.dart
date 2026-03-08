import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class SatoshiDataContainer extends StatelessWidget {
  final Widget child; // ¡Aquí está la magia! Recibe cualquier contenido.
  final EdgeInsetsGeometry padding;

  const SatoshiDataContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.deepNavy, // El color consistente de tus tarjetas
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blueGray.withValues(alpha: .1)),
      ),
      child: child,
    );
  }
}
