import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Importante para usar ConsumerWidget
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/core/widgets/app_widgets.dart';
import 'package:satoshimex/features/wallet/presentation/providers/wallet_provider.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos el estado del provider (Triple bifurcación automática)
    final walletStatusAsync = ref.watch(walletStateProvider);

    return walletStatusAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryAmber),
        ),
      ),
      error: (err, stack) => Scaffold(
        body: Center(
          child: Text(
            'Error al cargar la billetera: $err',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),

      data: (status) {
        //Si no a visto el tutorial, lo redirigimos
        if (status == WalletStatus.needsIntro) {
          Future.microtask(() {
            if (!context.mounted) return;
            context.push('/onboarding_wallet');
          });
          return const SizedBox.shrink();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Billetera de aprendizaje',
              style: GoogleFonts.lexend(color: Colors.white, fontSize: 20),
            ),
            centerTitle: true,
          ),
          body: SafeArea(child: _buildWalletCard(context, ref, status)),
        );
      },
    );
  }

  Widget _buildWalletCard(
    BuildContext context,
    WidgetRef ref,
    WalletStatus status,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: AppColors.deepNavy,
              border: Border.all(color: AppColors.slateBlueGray),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryAmber.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.account_balance_wallet_outlined,
                      color: AppColors.primaryAmber,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Crea tu billetera de simulación para comenzar a aprender...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                SatoshiButton(
                  text: status == WalletStatus.needsCreation
                      ? 'Crear billetera'
                      : 'Ir a mi billetera',
                  icon: Icons.add_circle_outline,
                  onPressed: () {
                    if (status == WalletStatus.needsCreation) {
                      context.push('/create_wallet');
                    } else if (status == WalletStatus.ready) {
                      context.push('/wallet_dashboard');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
