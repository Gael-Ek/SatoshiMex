import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/core/widgets/app_widgets.dart';
import 'package:satoshimex/core/services/bitcoin_api_service.dart';

// NUESTROS LEGOS
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_learning_progress.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/satoshi_data_container.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/satoshi_warning_card.dart';

class WalletSendStepFourScreen extends StatefulWidget {
  final String address;
  final double amount;
  final int feeSats;
  final double totalBtc;

  const WalletSendStepFourScreen({
    super.key,
    required this.address,
    required this.amount,
    required this.feeSats,
    required this.totalBtc,
  });

  @override
  State<WalletSendStepFourScreen> createState() =>
      _WalletSendStepFourScreenState();
}

class _WalletSendStepFourScreenState extends State<WalletSendStepFourScreen> {
  bool _isLoading = true;
  bool _isChecked = false; // Estado del checkbox

  String _recipientName = 'Desconocido';
  double _amountInMxn = 0.0;

  @override
  void initState() {
    super.initState();
    _loadFinalData();
  }

  Future<void> _loadFinalData() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Buscar el nombre del destinatario en nuestra "Base de datos"
    final listStr = prefs.getStringList('walletRecipients') ?? [];
    for (var item in listStr) {
      try {
        final map = jsonDecode(item);
        if (map['address'] == widget.address) {
          _recipientName = map['name'];
          break;
        }
      } catch (_) {}
    }

    // 2. Traer el precio actual para la conversión
    final priceFromApi = await BitcoinApiService.getBitcoinPriceInMXN();

    setState(() {
      _amountInMxn = widget.amount * priceFromApi;
      _isLoading = false;
    });
  }

  // Utilidad para formatear números
  String _formatNumber(double number, {bool isCurrency = false}) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String mathFunc(Match match) => '${match[1]},';
    if (isCurrency) {
      return number.toStringAsFixed(2).replaceAllMapped(reg, mathFunc);
    }
    return number.truncate().toString().replaceAllMapped(reg, mathFunc);
  }

  String _formatBtc(double btc) {
    return btc.toStringAsFixed(8).replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');
  }

  // LÓGICA CORE: Ejecutar la transacción simulada
  Future<void> _confirmAndSend() async {
    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, marca la casilla de verificación para continuar.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Mostramos que está "procesando"
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();

    // 1. Leemos el saldo actual
    final savedBalance = prefs.getString('simulatedBalance') ?? '0.001 BTC';
    final currentBalance =
        double.tryParse(savedBalance.replaceAll(' BTC', '').trim()) ?? 0.0;

    // 2. Restamos el total (Monto + Comisión)
    double newBalance = currentBalance - widget.totalBtc;

    // Seguridad extra: no permitir saldo negativo por errores de redondeo
    if (newBalance < 0) newBalance = 0.0;

    // 3. Guardamos el nuevo saldo en memoria
    await prefs.setString('simulatedBalance', '${_formatBtc(newBalance)} BTC');

    // 3. Guardamos el nuevo saldo en memoria
    await prefs.setString('simulatedBalance', '${_formatBtc(newBalance)} BTC');

    // ==========================================
    // NUEVO: GUARDAR LA TRANSACCIÓN EN EL HISTORIAL
    // ==========================================
    // A. Traemos el historial actual (o una lista vacía si no hay)
    final txList = prefs.getStringList('walletTransactions') ?? [];

    // B. Creamos el recibo en JSON
    final newTx = jsonEncode({
      'type': 'ENVIADO',
      'amountBtc': widget.totalBtc, // Guardamos el total con comisión
      'recipientName': _recipientName,
      'date': DateTime.now()
          .toIso8601String(), // Guardamos la fecha y hora exacta
    });

    // C. Lo insertamos al principio de la lista (para que salga hasta arriba)
    txList.insert(0, newTx);

    // D. Lo guardamos en la memoria
    await prefs.setStringList('walletTransactions', txList);
    // ==========================================

    // 4. Simulamos un pequeño retraso de red (para darle realismo de que viaja en la blockchain)
    await Future.delayed(const Duration(seconds: 2));

    if (context.mounted) {
      // ¡En lugar de ir al Dashboard, vamos a la nueva pantalla de Éxito!
      context.go(
        '/wallet-send-success',
        extra: {
          'recipientName': _recipientName,
          'amount': widget.amount,
          'feeSats': widget.feeSats,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.blueDark,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.primaryAmber),
              SizedBox(height: 16),
              Text(
                'Firmando transacción...',
                style: TextStyle(
                  color: AppColors.primaryAmber,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Determinamos qué texto poner de comisión según los Sats
    String feeType = widget.feeSats == 2000
        ? 'Baja'
        : widget.feeSats == 4200
        ? 'Media'
        : 'Alta';

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
          'Revisión y Confirmación',
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
              // Título consistente y Barra final
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
              const WalletLearningProgress(currentStep: 4, totalSteps: 4),
              const SizedBox(height: 32),

              // Contenedor de Recibo
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SatoshiDataContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Destinatario
                            Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.charcoalBlack,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.primaryAmber.withOpacity(
                                        0.5,
                                      ),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.person_outline,
                                    color: AppColors.primaryAmber.withOpacity(
                                      0.8,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'DESTINATARIO',
                                      style: TextStyle(
                                        color: AppColors.blueGray,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                    Text(
                                      _recipientName,
                                      style: const TextStyle(
                                        color: AppColors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Dirección
                            const Text(
                              'DIRECCIÓN DE BITCOIN',
                              style: TextStyle(
                                color: AppColors.blueGray,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.charcoalBlack,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                widget.address,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 13,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),

                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Divider(
                                color: AppColors.charcoalBlack,
                                thickness: 2,
                              ),
                            ),

                            // Monto a enviar
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Monto a enviar',
                                  style: TextStyle(
                                    color: AppColors.blueGray,
                                    fontSize: 14,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${_formatBtc(widget.amount)} BTC',
                                      style: const TextStyle(
                                        color: AppColors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '≈ \$${_formatNumber(_amountInMxn, isCurrency: true)} MXN',
                                      style: const TextStyle(
                                        color: AppColors.blueGray,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Comisión
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Comisión de red',
                                  style: TextStyle(
                                    color: AppColors.blueGray,
                                    fontSize: 14,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      feeType,
                                      style: const TextStyle(
                                        color: AppColors.primaryAmber,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${_formatNumber(widget.feeSats.toDouble())} SATS',
                                      style: const TextStyle(
                                        color: AppColors.blueGray,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Total final
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total a deducir',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${_formatBtc(widget.totalBtc)} BTC',
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Tarjeta de advertencia reciclada
                      const SatoshiWarningCard(
                        title: 'Recuerda',
                        description:
                            'Una vez enviada una transacción real en la red Bitcoin, no se puede deshacer. Siempre verifica la dirección de destino.',
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Zona de Confirmación (Checkbox y Botón)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _isChecked,
                      activeColor: AppColors.primaryAmber,
                      checkColor: AppColors.charcoalBlack,
                      side: const BorderSide(color: AppColors.blueGray),
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value ?? false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'He verificado que la dirección y el monto son correctos.',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              SatoshiButton(
                text: 'Confirmar y enviar simulación',
                icon: Icons.send,
                onPressed: _confirmAndSend, // Ejecuta la magia
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Esta es una simulación segura. No se enviará dinero real.',
                  style: TextStyle(
                    color: AppColors.blueGray,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
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
}
