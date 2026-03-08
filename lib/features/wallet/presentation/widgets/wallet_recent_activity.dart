import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class WalletRecentActivity extends StatefulWidget {
  const WalletRecentActivity({super.key});

  @override
  State<WalletRecentActivity> createState() => _WalletRecentActivityState();
}

class _WalletRecentActivityState extends State<WalletRecentActivity> {
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  // 1. Ir a la memoria por los recibos
  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final txListStr = prefs.getStringList('walletTransactions') ?? [];

    final List<Map<String, dynamic>> loaded = [];
    for (var item in txListStr) {
      try {
        loaded.add(jsonDecode(item)); // Decodificamos el JSON
      } catch (e) {
        debugPrint('Error leyendo transacción: $e');
      }
    }

    setState(() {
      _transactions = loaded;
      _isLoading = false;
    });
  }

  // Utilidad para formatear la fecha (Ej: 14/08/2026)
  String _formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // Utilidad para formatear BTC
  String _formatBtc(double btc) {
    return btc.toStringAsFixed(8).replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryAmber),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título
        const Text(
          'ACTIVIDAD RECIENTE',
          style: TextStyle(
            color: AppColors.blueGray,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 16),

        // 2. ¿No hay transacciones? Mostramos un mensaje bonito.
        if (_transactions.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.deepNavy,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.blueGray.withOpacity(0.1)),
            ),
            child: const Center(
              child: Text(
                'Aún no tienes transacciones.\n¡Intenta simular un envío!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blueGray,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          )
        // 3. ¡Si hay transacciones, las dibujamos dinámicamente!
        else
          ..._transactions.map((tx) => _buildTransactionItem(tx)),
      ],
    );
  }

  // El diseño de cada tarjetita de transacción
  Widget _buildTransactionItem(Map<String, dynamic> tx) {
    final isSend = tx['type'] == 'ENVIADO';
    final amountText = _formatBtc(tx['amountBtc'] ?? 0.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.deepNavy,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blueGray.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // Icono circular (Flecha roja para envíos)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: AppColors.charcoalBlack,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSend ? Icons.arrow_upward : Icons.arrow_downward,
              color: isSend ? Colors.redAccent : AppColors.primaryAmber,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),

          // Textos del centro
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSend ? 'Enviado a ${tx['recipientName']}' : 'Recibido',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(tx['date']),
                  style: const TextStyle(
                    color: AppColors.blueGray,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Monto a la derecha
          Text(
            '${isSend ? '-' : '+'}$amountText BTC',
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
