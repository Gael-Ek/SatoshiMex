import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/core/widgets/app_widgets.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/satoshi_data_container.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/satoshi_warning_card.dart';

class WalletReceiveScreen extends StatefulWidget {
  const WalletReceiveScreen({super.key});

  @override
  State<WalletReceiveScreen> createState() => _WalletReceiveScreenState();
}

class _WalletReceiveScreenState extends State<WalletReceiveScreen> {
  String _address = 'Cargando...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  // Vamos a la memoria a buscar la dirección única del usuario
  Future<void> _loadAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _address = prefs.getString('simulatedAddress') ?? 'bc1q...';
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.blueDark,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryAmber),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.blueDark, // FONDO REGLA DE ORO
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.pop(), // La flecha para retroceder
        ),
        title: const Text(
          'Aprende a recibir Bitcoin',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
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
              const Text(
                'Aprende a recibir Bitcoin',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Para recibir Bitcoin, solo necesitas compartir tu dirección de billetera. Funciona como un número de cuenta único.',
                style: TextStyle(
                  color: AppColors.blueGray,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

              // ¡USAMOS NUESTRO CONTENEDOR MULTIPROPÓSITO!
              SatoshiDataContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TU DIRECCIÓN DE BITCOIN',
                      style: TextStyle(
                        color: AppColors.primaryAmber,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Cajita más oscura para la dirección simulando un input
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.charcoalBlack,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _address, // Pintamos la variable de la memoria
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Textito de información
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info,
                          color: AppColors.primaryAmber,
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'La persona que quiera enviarte Bitcoin debe usar exactamente esta dirección.',
                            style: TextStyle(
                              color: AppColors.blueGray,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ¡USAMOS NUESTRA TARJETA DE ADVERTENCIA!
              const SatoshiWarningCard(
                title: 'Verifica siempre los caracteres',
                description:
                    'Las direcciones son sensibles. Un solo error hará que los fondos se pierdan para siempre. No necesitas enviar nada para recibir.',
              ),

              const Spacer(), // Empuja el botón hasta abajo
              // Botón inferior
              SatoshiButton(
                text: 'Entendido, continuar',
                onPressed: () {
                  context.pop(); // Regresa al Dashboard de la billetera
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
