import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:satoshimex/core/config/constants/app_colors.dart';

// Widgets de la billetera
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_balance_card.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_action_buttons.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_quick_conversion.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_learning_missions.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_recent_activity.dart';

// Servicio para obtener precio de Bitcoin
import 'package:satoshimex/core/services/bitcoin_api_service.dart';

class WalletDashboardScreen extends StatefulWidget {
  const WalletDashboardScreen({super.key});

  @override
  State<WalletDashboardScreen> createState() => _WalletDashboardScreenState();
}

class _WalletDashboardScreenState extends State<WalletDashboardScreen> {
  // Saldo simulado del usuario
  String _balance = '0.001 BTC';

  // Precio real del BTC en MXN
  double _currentBtcPrice = 0.0;

  // Control de carga
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  // Cargar datos del dashboard
  Future<void> _loadDashboardData() async {
    // 1️ Leer saldo guardado en el dispositivo
    final prefs = await SharedPreferences.getInstance();
    final savedBalance = prefs.getString('simulatedBalance') ?? '0.001 BTC';

    // 2️ Obtener precio real de BTC desde la API
    final priceFromApi = await BitcoinApiService.getBitcoinPriceInMXN();

    // 3️ Actualizar estado de la pantalla
    setState(() {
      _balance = savedBalance;
      _currentBtcPrice = priceFromApi;
      _isLoading = false;
    });

    debugPrint('Precio BTC cargado: \$$_currentBtcPrice MXN');
  }

  @override
  Widget build(BuildContext context) {
    // Pantalla de carga
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.blueDark,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryAmber),
        ),
      );
    }

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
          'Billetera',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1️ Tarjeta de saldo
              // 1️ Tarjeta de saldo inyectando el precio real de internet
              WalletBalanceCard(
                balance: _balance,
                btcPriceInMxn: _currentBtcPrice, // ¡Conectamos la tubería!
              ),

              const SizedBox(height: 24),

              // 2️ Botones de acción
              const WalletActionButtons(),

              const SizedBox(height: 32),

              // 3️ Conversión rápida
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.deepNavy,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.blueGray.withOpacity(0.1),
                  ),
                ),
                child: WalletQuickConversion(
                  btcPriceInMxn:
                      _currentBtcPrice, // ¡Le inyectamos el precio de internet!
                ),
              ),

              const SizedBox(height: 32),

              // 4️⃣ Misiones de aprendizaje
              const WalletLearningMissions(),

              const SizedBox(height: 32),

              // 5️⃣ Actividad reciente
              const WalletRecentActivity(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
