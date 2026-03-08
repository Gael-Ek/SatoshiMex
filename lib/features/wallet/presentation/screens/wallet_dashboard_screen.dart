import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:satoshimex/core/providers/bitcoin_price_provider.dart';
import 'package:satoshimex/features/wallet/presentation/providers/wallet_provider.dart';

import 'package:satoshimex/core/config/constants/app_colors.dart';

import 'package:satoshimex/features/wallet/presentation/widgets/wallet_balance_card.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_action_buttons.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_quick_conversion.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_learning_missions.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_recent_activity.dart';

class WalletDashboardScreen extends ConsumerStatefulWidget {
  const WalletDashboardScreen({super.key});

  @override
  ConsumerState<WalletDashboardScreen> createState() =>
      _WalletDashboardScreenState();
}

class _WalletDashboardScreenState extends ConsumerState<WalletDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final walletDataAsync = ref.watch(walletDataProvider);

    final btcPriceAsync = ref.watch(bitcoinPriceProvider);

    if (walletDataAsync.isLoading || btcPriceAsync.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.blueDark,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryAmber),
        ),
      );
    }

    return walletDataAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.blueDark,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryAmber),
        ),
      ),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (data) {
        final walletData = walletDataAsync.value;
        final balance = walletData?['balance'] ?? '0.00 BTC';
        final currentBtcPrice = btcPriceAsync.value ?? 1000000.0;

        return Scaffold(
          appBar: AppBar(
            elevation: 0,

            title: const Text(
              'Billetera',

              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
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
                  //Tarjeta de saldo
                  WalletBalanceCard(
                    balance: balance,
                    btcPriceInMxn: currentBtcPrice,
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
                        color: AppColors.blueGray.withValues(alpha: .1),
                      ),
                    ),

                    child: WalletQuickConversion(
                      btcPriceInMxn: currentBtcPrice,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 4️ Misiones de aprendizaje
                  const WalletLearningMissions(),

                  const SizedBox(height: 32),

                  // 5️ Actividad reciente
                  const WalletRecentActivity(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
