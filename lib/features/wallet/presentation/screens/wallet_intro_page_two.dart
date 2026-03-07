import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

// Importa tus widgets (ajusta la ruta según tu app_widgets.dart)
import 'package:satoshimex/core/widgets/app_widgets.dart'; // Para el SatoshiButton
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_learning_progress.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_checklist_item.dart';

class WalletIntroPageTwo extends StatelessWidget {
  const WalletIntroPageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueDark,
      // Usamos AppBar para el encabezado con la flecha
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Billetera de Entrenamiento',
          style: TextStyle(color: AppColors.white, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. Marca de agua en el fondo (Birrete gigante)
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.03, // Muy transparente
              child: const Icon(
                Icons.school,
                size: 250,
                color: AppColors.primaryAmber,
              ),
            ),
          ),

          // 2. Contenido principal
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // Barra de progreso (Paso 2 de 3)
                  const WalletLearningProgress(currentStep: 2, totalSteps: 3),

                  const SizedBox(height: 32),

                  // Textos de título
                  const Text(
                    'Lo que aprenderás',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Domina los conceptos básicos antes de empezar a operar con fondos reales.',
                    style: TextStyle(color: AppColors.blueGray, fontSize: 16),
                  ),

                  const SizedBox(height: 32),

                  // Lista de objetivos usando tu nuevo widget
                  const WalletChecklistItem(title: 'Enviar Bitcoin'),
                  const WalletChecklistItem(title: 'Verificar direcciones'),
                  const WalletChecklistItem(
                    title: 'Confirmaciones de transacción',
                  ),
                  const WalletChecklistItem(
                    title: 'Cómo funciona la red Bitcoin',
                  ),

                  const Spacer(),

                  // Botones inferiores
                  SatoshiButton(
                    text: 'Siguiente',
                    // No le pasamos el 'icon' para que salga sin flecha, igual al boceto
                    onPressed: () {
                      context.push('/wallet-intro-3');
                      debugPrint('Ir a la página 3');
                    },
                  ),
                  const SizedBox(height: 16),

                  // Botón Atrás (Secundario oscuro)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.charcoalBlack,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Atrás',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
