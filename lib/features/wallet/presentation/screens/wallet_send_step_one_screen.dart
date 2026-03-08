import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/core/widgets/app_widgets.dart';

// Importamos nuestros Legos
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_learning_progress.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/satoshi_warning_card.dart';

// Modelo de datos para los contactos (JSON Parsing)
class Recipient {
  final String name;
  final String address;
  Recipient({required this.name, required this.address});
}

class WalletSendStepOneScreen extends StatefulWidget {
  const WalletSendStepOneScreen({super.key});

  @override
  State<WalletSendStepOneScreen> createState() =>
      _WalletSendStepOneScreenState();
}

class _WalletSendStepOneScreenState extends State<WalletSendStepOneScreen> {
  final TextEditingController _addressController = TextEditingController();
  List<Recipient> _recipients = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecipients();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  // Leer base de datos local JSON
  Future<void> _loadRecipients() async {
    final prefs = await SharedPreferences.getInstance();
    final listStr = prefs.getStringList('walletRecipients') ?? [];

    final List<Recipient> loaded = [];
    for (var item in listStr) {
      try {
        final map = jsonDecode(item);
        loaded.add(Recipient(name: map['name'], address: map['address']));
      } catch (e) {
        debugPrint('Error al decodificar contacto: $e');
      }
    }

    setState(() {
      _recipients = loaded;
      _isLoading = false;
    });
  }

  // Lógica Reactiva: Pegar dirección
  void _selectRecipient(String address) {
    setState(() {
      _addressController.text = address;
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
      backgroundColor: AppColors.blueDark, // REGLA DE ORO
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Billetera',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CORRECCIÓN 1: Eliminado el texto redundante y el Row.
              // Usamos Column para que el título baje de línea naturalmente.
              const Text(
                'Simular envío de\nBitcoin',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              const WalletLearningProgress(currentStep: 1, totalSteps: 4),
              const SizedBox(height: 32),

              // Contenedor del Input de Dirección
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.deepNavy,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.blueGray.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dirección del destinatario',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.charcoalBlack,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.blueGray.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _addressController,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 13,
                                letterSpacing: 1.0,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'bc1q...',
                                hintStyle: TextStyle(color: AppColors.blueGray),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.qr_code_scanner,
                            color: AppColors.primaryAmber,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Las direcciones de Bitcoin son únicas para cada usuario.',
                      style: TextStyle(
                        color: AppColors.blueGray,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Lista de Contactos
              const Text(
                'DESTINATARIOS GUARDADOS',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 16),

              // CORRECCIÓN 2: Eliminado el SizedBox(height: 80) hardcodeado.
              // Usamos IntrinsicHeight para que la lista calcule su propio alto perfecto y no haya overflow.
              IntrinsicHeight(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      // Mapeamos nuestra lista de contactos a Avatares
                      ..._recipients.map(
                        (recipient) => Padding(
                          padding: const EdgeInsets.only(right: 24.0),
                          child: _buildAvatar(
                            name: recipient.name,
                            initial: recipient.name.isNotEmpty
                                ? recipient.name[0].toUpperCase()
                                : '?',
                            onTap: () => _selectRecipient(recipient.address),
                          ),
                        ),
                      ),

                      // Botón para crear uno Nuevo
                      _buildAvatar(
                        name: 'Nuevo',
                        icon: Icons.add,
                        isDashed: true,
                        // Al volver recargamos la lista
                        onTap: () => context
                            .push('/add-recipient-1')
                            .then((_) => _loadRecipients()),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Reutilizamos el Warning Card (Consistencia al 100%)
              const SatoshiWarningCard(
                title: 'Siempre verifica los caracteres',
                description:
                    'Verifica los primeros 4 y últimos 4 caracteres antes de enviar. Ej: bc1q...3f8a',
              ),

              const Spacer(),

              // Botón Continuar
              SatoshiButton(
                text: 'Continuar',
                onPressed: () {
                  if (_addressController.text.trim().isNotEmpty) {
                    // Si hay dirección, avanzamos al Paso 2 (Monto)
                    context.push(
                      '/wallet-send-step-2',
                      extra: _addressController.text.trim(),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ingresa o selecciona una dirección'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'En el siguiente paso elegirás la cantidad de Bitcoin\nque deseas enviar.',
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

  // Widget de apoyo para los Avatares
  Widget _buildAvatar({
    required String name,
    String? initial,
    IconData? icon,
    bool isDashed = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Importante para IntrinsicHeight
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.charcoalBlack,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryAmber.withOpacity(0.5),
                style: BorderStyle.solid,
                width: 2,
              ),
            ),
            child: Center(
              child: icon != null
                  ? Icon(icon, color: AppColors.primaryAmber)
                  : Text(
                      initial ?? '',
                      style: const TextStyle(
                        color: AppColors.primaryAmber,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          // Usamos Flexible para asegurar que el texto no empuje el diseño hacia abajo
          Flexible(
            child: Text(
              name,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              overflow:
                  TextOverflow.ellipsis, // Si el nombre es largo, pone "..."
            ),
          ),
        ],
      ),
    );
  }
}
