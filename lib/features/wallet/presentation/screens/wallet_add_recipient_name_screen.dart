import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/core/widgets/app_widgets.dart'; // Tu SatoshiButton

// Importa tus widgets reciclables
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_learning_progress.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/satoshi_data_container.dart';

class WalletAddRecipientNameScreen extends StatefulWidget {
  const WalletAddRecipientNameScreen({super.key});

  @override
  State<WalletAddRecipientNameScreen> createState() =>
      _WalletAddRecipientNameScreenState();
}

class _WalletAddRecipientNameScreenState
    extends State<WalletAddRecipientNameScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Función para rellenar el input si tocan una sugerencia
  void _fillSuggestion(String name) {
    setState(() {
      _nameController.text = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueDark, // REGLA DE ORO
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Crear destinatario',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Reutilizamos la barra de progreso
              const WalletLearningProgress(currentStep: 1, totalSteps: 2),
              const SizedBox(height: 32),

              const Text(
                'Crear destinatario',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Para enviar Bitcoin necesitas la dirección de la persona que recibirá la transacción.',
                style: TextStyle(
                  color: AppColors.blueGray,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

              // Nuestro Contenedor Camaleón
              SatoshiDataContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryAmber,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              '1',
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Paso 1: Nombre del destinatario',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Apodo o nombre',
                      style: TextStyle(
                        color: AppColors.blueGray,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Input oscuro
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.charcoalBlack,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.blueGray.withOpacity(0.2),
                        ),
                      ),
                      child: TextField(
                        controller: _nameController,
                        style: const TextStyle(color: AppColors.white),
                        decoration: const InputDecoration(
                          hintText: 'Ej: Mi Wallet Personal',
                          hintStyle: TextStyle(color: AppColors.blueGray),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'SUGERENCIAS',
                      style: TextStyle(
                        color: AppColors.blueGray,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildSuggestionAvatar('A', 'Alice'),
                        const SizedBox(width: 24),
                        _buildSuggestionAvatar('B', 'Bob'),
                        const SizedBox(width: 24),
                        _buildSuggestionAvatar('S', 'Satoshi'),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Cuadro de información integrado (sin borde ámbar para distinguir del Warning)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.charcoalBlack.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info,
                            color: AppColors.primaryAmber.withOpacity(0.8),
                            size: 18,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Este nombre solo te ayudará a identificar a quién envías Bitcoin. No es necesario el nombre legal.',
                              style: TextStyle(
                                color: AppColors.blueGray,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              SatoshiButton(
                text: 'Continuar',
                icon: Icons.arrow_forward_ios,
                onPressed: () {
                  final name = _nameController.text.trim();
                  if (name.isNotEmpty) {
                    // ¡Enviamos el nombre como paquete (extra) a la pantalla 2!
                    context.push('/add-recipient-2', extra: name);
                  } else {
                    // Snack bar de error si está vacío
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Por favor ingresa un nombre o elige una sugerencia',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Cada persona tiene una dirección Bitcoin única\npara recibir fondos. Asegúrate de pedir la\ndirección correcta.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.blueGray,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para las sugerencias circulares
  Widget _buildSuggestionAvatar(String initial, String name) {
    return GestureDetector(
      onTap: () => _fillSuggestion(name),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.charcoalBlack,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryAmber.withOpacity(0.5),
              ),
            ),
            child: Center(
              child: Text(
                initial,
                style: const TextStyle(
                  color: AppColors.primaryAmber,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(color: AppColors.blueGray, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
