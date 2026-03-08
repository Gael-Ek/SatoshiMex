import 'dart:convert'; // Necesario para el JSON
import 'dart:math'; // Para generar números aleatorios
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/core/widgets/app_widgets.dart';

import 'package:satoshimex/features/wallet/presentation/widgets/wallet_learning_progress.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/satoshi_data_container.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/satoshi_warning_card.dart';

class WalletAddRecipientAddressScreen extends StatefulWidget {
  final String recipientName; // Recibe el nombre de la Pantalla 1

  const WalletAddRecipientAddressScreen({
    super.key,
    required this.recipientName,
  });

  @override
  State<WalletAddRecipientAddressScreen> createState() =>
      _WalletAddRecipientAddressScreenState();
}

class _WalletAddRecipientAddressScreenState
    extends State<WalletAddRecipientAddressScreen> {
  String _generatedAddress = '';

  @override
  void initState() {
    super.initState();
    _generateSimulatedAddress();
  }

  // Generador de dirección criptográfica falsa (Estilo SegWit)
  void _generateSimulatedAddress() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    String suffix = String.fromCharCodes(
      Iterable.generate(
        38,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
    setState(() {
      _generatedAddress = 'bc1q$suffix';
    });
  }

  // LÓGICA DE BACKEND: Guardar el contacto en JSON
  Future<void> _saveRecipientAndFinish() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Traemos la lista actual de contactos (o una vacía si no hay)
    List<String> recipientsList = prefs.getStringList('walletRecipients') ?? [];

    // 2. Creamos el nuevo contacto en formato JSON
    final newRecipientJson = jsonEncode({
      'name': widget.recipientName,
      'address': _generatedAddress,
    });

    // 3. Lo agregamos a la lista y guardamos
    recipientsList.add(newRecipientJson);
    await prefs.setStringList('walletRecipients', recipientsList);

    // 4. Vamos al Home de Destinatarios (Siguiente pantalla que crearemos)
    if (context.mounted) {
      // Por ahora regresaremos al Dashboard mientras creamos la libreta
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Contacto guardado con éxito!'),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/wallet-dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueDark,
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
              const WalletLearningProgress(currentStep: 2, totalSteps: 2),
              const SizedBox(height: 32),

              Text(
                'Dirección para ${widget.recipientName}',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Hemos generado una dirección segura de simulación para este destinatario.',
                style: TextStyle(
                  color: AppColors.blueGray,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

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
                              '2',
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
                          'Paso 2: Dirección generada',
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
                      'DIRECCIÓN BITCOIN (SIMULADA)',
                      style: TextStyle(
                        color: AppColors.primaryAmber,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.charcoalBlack,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _generatedAddress,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ¡Reutilizamos la tarjeta de advertencia!
              const SatoshiWarningCard(
                title: 'No uses esta dirección',
                description:
                    'Esta es una dirección generada únicamente para fines educativos dentro de SatoshiMex. Si envías Bitcoin real aquí, se perderá para siempre.',
              ),

              const Spacer(),

              SatoshiButton(
                text: 'Guardar Contacto',
                icon: Icons.check_circle_outline,
                onPressed: _saveRecipientAndFinish,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
