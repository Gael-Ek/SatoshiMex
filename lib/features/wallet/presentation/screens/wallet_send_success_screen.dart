import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/core/widgets/app_widgets.dart';

// NUESTROS LEGOS
import 'package:satoshimex/features/wallet/presentation/widgets/satoshi_data_container.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/satoshi_warning_card.dart';

class WalletSendSuccessScreen extends StatefulWidget {
  final String recipientName;
  final double amount;
  final int feeSats;

  const WalletSendSuccessScreen({
    super.key,
    required this.recipientName,
    required this.amount,
    required this.feeSats,
  });

  @override
  State<WalletSendSuccessScreen> createState() =>
      _WalletSendSuccessScreenState();
}

class _WalletSendSuccessScreenState extends State<WalletSendSuccessScreen> {
  late String _txId;

  @override
  void initState() {
    super.initState();
    _txId = _generateMockTxId();
  }

  // Generar un ID de transacción aleatorio estilo hexadecimal
  String _generateMockTxId() {
    const chars = 'abcdef0123456789';
    final random = Random();
    String start = String.fromCharCodes(
      Iterable.generate(
        4,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
    String end = String.fromCharCodes(
      Iterable.generate(
        4,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
    return '$start...$end';
  }

  // Utilidad para formatear BTC sin ceros extra
  String _formatBtc(double btc) {
    return btc.toStringAsFixed(8).replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');
  }

  // Utilidad para formatear SATS
  String _formatSats(int sats) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String mathFunc(Match match) => '${match[1]},';
    return sats.toString().replaceAllMapped(reg, mathFunc);
  }

  @override
  Widget build(BuildContext context) {
    // Determinamos el texto de la comisión
    String feeLevel = widget.feeSats == 2000
        ? 'Baja'
        : widget.feeSats == 4200
        ? 'Media'
        : 'Alta';

    // Para evitar que el usuario use el botón físico de "Atrás" de Android y regrese al Paso 4
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.blueDark,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false, // Quitamos la flecha de retroceso
          title: const Text(
            'Confirmación',
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),

                // Icono de Éxito Gigante
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primaryAmber,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryAmber.withValues(alpha: .3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppColors.blueDark,
                    size: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  '¡Transacción Enviada!',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tu simulación ha sido procesada con éxito.',
                  style: TextStyle(color: AppColors.blueGray, fontSize: 14),
                ),
                const SizedBox(height: 32),

                // Contenedor de Detalles (SatoshiDataContainer)
                SatoshiDataContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DETALLES DE LA SIMULACIÓN',
                        style: TextStyle(
                          color: AppColors.primaryAmber,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 24),

                      _buildDetailRow('Destinatario', widget.recipientName),
                      const SizedBox(height: 16),

                      _buildDetailRow(
                        'Monto',
                        '${_formatBtc(widget.amount)} BTC',
                        isHighlight: true,
                      ),
                      const SizedBox(height: 16),

                      _buildDetailRow(
                        'Comisión',
                        '$feeLevel (${_formatSats(widget.feeSats)} SATS)',
                      ),
                      const SizedBox(height: 16),

                      const Divider(
                        color: AppColors.charcoalBlack,
                        thickness: 2,
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ID Transacción',
                            style: TextStyle(
                              color: AppColors.blueGray,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                _txId,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 14,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.copy,
                                color: AppColors.primaryAmber,
                                size: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Tarjeta Warning Educativa
                const SatoshiWarningCard(
                  title: 'Confirmación de mineros',
                  description:
                      'En la red Bitcoin real, tu transacción ahora estaría esperando confirmación de los mineros. Esto puede tardar unos 10-20 minutos según la comisión elegida.',
                ),

                const Spacer(),

                // UN SOLO BOTÓN como solicitaste
                SatoshiButton(
                  text: 'Volver a la Billetera',
                  onPressed: () {
                    // Limpiamos el historial de navegación y vamos al Dashboard
                    context.go('/wallet_dashboard');
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Recuerda: Esta es una simulación segura. No se ha enviado\ndinero real.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.blueGray,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Mini-widget para las filas de detalles
  Widget _buildDetailRow(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.blueGray, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            color: isHighlight ? AppColors.primaryAmber : AppColors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
