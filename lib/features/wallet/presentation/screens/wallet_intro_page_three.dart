import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Nuestra regla de oro para los colores:
import 'package:satoshimex/core/config/constants/app_colors.dart';

// Importamos los widgets que vamos a reciclar:
import 'package:satoshimex/core/widgets/app_widgets.dart'; // Para el SatoshiButton
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_page_indicator.dart'; // Para los puntitos
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_learning_progress.dart'; // Para la barra de progreso
import 'package:shared_preferences/shared_preferences.dart'; // Para guardar la memoria

class WalletIntroPageThree extends StatelessWidget {
  const WalletIntroPageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueDark,

      // AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Guía',
          style: TextStyle(color: AppColors.white, fontSize: 16),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),

          child: Column(
            children: [
              const SizedBox(height: 16),

              // --- BARRA DE PROGRESO DEL APRENDIZAJE ---
              const WalletLearningProgress(currentStep: 3, totalSteps: 3),

              const SizedBox(height: 24),

              // 1. Contenedor de la Imagen con la etiqueta
              Stack(
                children: [
                  // Imagen con bordes redondeados
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      color: AppColors.charcoalBlack,

                      // Imagen temporal
                      child: const Center(
                        child: Icon(
                          Icons.image,
                          color: AppColors.blueGray,
                          size: 50,
                        ),
                      ),
                    ),
                  ),

                  // Etiqueta flotante
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryAmber,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'SIMULACIÓN ACTIVA',
                        style: TextStyle(
                          color: AppColors.charcoalBlack,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // 2. Título
              const Text(
                'Modo Simulación',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // 3. Descripción
              const Text(
                'Todas las operaciones aquí son simulaciones seguras para aprender. Puedes cometer errores y ver qué pasaría en la vida real sin arriesgar fondos.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blueGray,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),

              const Spacer(),

              // 4. Indicador de página
              const WalletPageIndicator(currentPage: 2),

              const SizedBox(height: 32),

              // 5. Botón principal
              // 5. Botón principal
              SatoshiButton(
                text: 'Comenzar entrenamiento',
                icon: Icons.play_circle_fill,
                onPressed: () async {
                  // 1. Abrimos la memoria interna del teléfono
                  final prefs = await SharedPreferences.getInstance();

                  // 2. Guardamos la bandera: ¡Ya vio el tutorial!
                  await prefs.setBool('hasSeenWalletIntro', true);

                  // 3. Verificamos que todo esté bien y lo mandamos a la Wallet
                  if (context.mounted) {
                    // Usamos context.go y NO context.push para borrar el historial del tutorial
                    context.go('/home');
                  }
                },
              ),

              const SizedBox(height: 24),

              // 6. Pie de página
              const Text(
                'PASO 3 DE 3 • BILLETERA DE ENTRENAMIENTO\nSATOSHIMX',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blueGray,
                  fontSize: 10,
                  letterSpacing: 1.0,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
