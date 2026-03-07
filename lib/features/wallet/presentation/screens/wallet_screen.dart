import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Para leer la memoria

import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/core/widgets/app_widgets.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isLoading = true; // Ruedita de carga mientras piensa
  bool _hasWallet = false; // Variable para saber si ya la creó

  @override
  void initState() {
    super.initState();
    _checkWalletStatus();
  }

  // LA TRIPLE BIFURCACIÓN (El Cerebro)
  Future<void> _checkWalletStatus() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Preguntamos si ya vio el tutorial
    final hasSeenIntro = prefs.getBool('hasSeenWalletIntro') ?? false;

    if (!mounted) return;

    // RUTA A (El Novato): Si no ha visto el tutorial, lo mandamos a la fuerza al paso 1
    if (!hasSeenIntro) {
      context.go('/wallet-intro-1');
      return; // Detenemos la función aquí para que no siga cargando nada más
    }

    // RUTA B o C: Ya vio el tutorial. Ahora preguntamos si ya creó la billetera
    setState(() {
      _hasWallet = prefs.getBool('hasWallet') ?? false;
      _isLoading =
          false; // Terminamos de pensar, ya podemos dibujar la pantalla
    });
  }

  @override
  Widget build(BuildContext context) {
    // Pantalla de carga mientras lee la memoria
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
      body: SafeArea(
        // RENDERIZADO CONDICIONAL:
        // Si _hasWallet es true -> Muestra la Billetera Lista (Ruta C)
        // Si _hasWallet es false -> Muestra el botón de Crear (Ruta B)
        child: _hasWallet
            ? _buildWalletReadyState(context)
            : _buildEmptyState(context),
      ),
    );
  }

  // =========================================================================
  // RUTA C: DISEÑO DE "BILLETERA LISTA" (Basado en tu última imagen)
  // =========================================================================
  Widget _buildWalletReadyState(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alineado a la izquierda
        children: [
          const Text(
            'Billetera',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tu billetera de aprendizaje está lista.',
            style: TextStyle(color: AppColors.blueGray, fontSize: 16),
          ),
          const SizedBox(height: 32),

          // Tarjeta unida sin bordes usando ClipRRect
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                // 1. MITAD SUPERIOR (Imagen y Círculo)
                Container(
                  width: double.infinity,
                  height: 180,
                  color: AppColors.charcoalBlack,
                  child: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: [
                      // Fondo de relleno mientras pones tu imagen de Bitcoin real
                      // TODO: Descomentar esto cuando tengas tu imagen en la carpeta assets
                      // Image.asset('assets/images/tu_imagen_bitcoin.png', fit: BoxFit.cover),

                      // Ícono gigante de fondo para que no se vea vacío por ahora
                      Opacity(
                        opacity: 0.15,
                        child: const Icon(
                          Icons.currency_bitcoin,
                          size: 140,
                          color: AppColors.primaryAmber,
                        ),
                      ),

                      // Círculo Naranja con el ícono
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryAmber,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            color: AppColors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. MITAD INFERIOR (Textos y Botón en Deep Navy)
                Container(
                  width: double.infinity,
                  color: AppColors.deepNavy,
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Practica cómo enviar y recibir Bitcoin dentro de esta billetera de simulación.',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Todas las transacciones son de práctica. No se utiliza dinero real.',
                        style: TextStyle(
                          color: AppColors.blueGray,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // BOTÓN FINAL (Este nos llevará al Dashboard de verdad en el futuro)
                      SatoshiButton(
                        text: 'Ir a mi billetera',
                        icon: Icons.arrow_forward,
                        onPressed: () {
                          // Aún no tenemos esta pantalla, por ahora solo imprimimos en consola
                          debugPrint(
                            'Redirigiendo al Dashboard de Gráficas y Transacciones...',
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // RUTA B: DISEÑO DE "ESTADO VACÍO" (Para crear la billetera)
  // =========================================================================
  Widget _buildEmptyState(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Alineado al centro
        children: [
          const Text(
            'Billetera',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Aún no tienes una billetera de aprendizaje.',
            style: TextStyle(color: AppColors.blueGray, fontSize: 16),
          ),
          const SizedBox(height: 40),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            decoration: BoxDecoration(
              color: AppColors.deepNavy,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.charcoalBlack.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: AppColors.charcoalBlack,
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
                  'Crea tu billetera de simulación para comenzar a aprender cómo funcionan las transacciones de Bitcoin.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Esta billetera es solo para practicar. No utiliza dinero real.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.blueGray, fontSize: 15),
                ),
                const SizedBox(height: 32),
                SatoshiButton(
                  text: 'Crear mi billetera',
                  icon: Icons.add_circle_outline,
                  onPressed: () {
                    // ¡Inicia el Setup de 3 pasos!
                    context.push('/wallet-setup-1');
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Podrás elegir un saldo inicial de práctica, generar tu dirección Bitcoin y comenzar a simular transacciones.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.slateBlueGray,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
