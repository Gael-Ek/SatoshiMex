import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class LogoBitcoin extends StatelessWidget {
  const LogoBitcoin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lo envolvemos en un Center para evitar que el 'stretch'
    // de la Columna principal lo estire y lo convierta en un óvalo.
    return Center(
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primaryAmber, width: 1),
        ),
        child: const Icon(
          Icons.currency_bitcoin,
          color: AppColors.primaryAmber,
          size: 35,
        ),
      ),
    );
  }
}
