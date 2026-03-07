import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

// 1. Ahora es un StatefulWidget para poder reaccionar al texto
class WalletQuickConversion extends StatefulWidget {
  final double btcPriceInMxn; // ¡Exigimos el precio de la API!

  const WalletQuickConversion({super.key, required this.btcPriceInMxn});

  @override
  State<WalletQuickConversion> createState() => _WalletQuickConversionState();
}

class _WalletQuickConversionState extends State<WalletQuickConversion> {
  // 2. Los "Cables" que escuchan el teclado del usuario
  final TextEditingController _btcController = TextEditingController();
  final TextEditingController _satsController = TextEditingController();

  // 3. Variables donde guardamos los resultados para pintarlos en pantalla
  String _mxnResult = '\$0.00 MXN';
  String _btcResult = '0.00000000 BTC';

  @override
  void initState() {
    super.initState();
    // 4. Conectamos los cables: cada vez que escriban, ejecutan la matemática
    _btcController.addListener(_calculateMxn);
    _satsController.addListener(_calculateBtc);
  }

  @override
  void dispose() {
    // 5. Buena práctica de Ingeniero: Destruir los cables al cerrar la pantalla
    _btcController.dispose();
    _satsController.dispose();
    super.dispose();
  }

  // Función para darle formato bonito al dinero (ej: 1,350,000.00)
  String _formatCurrency(double number) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String mathFunc(Match match) => '${match[1]},';
    return number.toStringAsFixed(2).replaceAllMapped(reg, mathFunc);
  }

  // LÓGICA 1: Escribe BTC -> Calcula MXN
  void _calculateMxn() {
    final text = _btcController.text.trim();
    if (text.isEmpty) {
      setState(() => _mxnResult = '\$0.00 MXN');
      return;
    }

    // Convertimos de texto a número de forma segura (tryParse)
    final double? btcAmount = double.tryParse(text);
    if (btcAmount != null) {
      // La Matemática: BTC escritos * Precio de la API
      final double mxn = btcAmount * widget.btcPriceInMxn;
      setState(() {
        _mxnResult = '\$${_formatCurrency(mxn)} MXN'; // Actualizamos la UI
      });
    }
  }

  // LÓGICA 2: Escribe SATS -> Calcula BTC
  void _calculateBtc() {
    final text = _satsController.text.trim();
    if (text.isEmpty) {
      setState(() => _btcResult = '0.00000000 BTC');
      return;
    }

    final double? satsAmount = double.tryParse(text);
    if (satsAmount != null) {
      // La Matemática: Satoshis / 100 Millones = BTC
      final double btc = satsAmount / 100000000;
      setState(() {
        // Le ponemos 8 decimales fijos, que es el estándar de Bitcoin
        _btcResult = '${btc.toStringAsFixed(8)} BTC';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'CONVERSIÓN RÁPIDA',
              style: TextStyle(
                color: AppColors.blueGray,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            Icon(Icons.swap_horiz, color: AppColors.primaryAmber, size: 18),
          ],
        ),
        const SizedBox(height: 16),

        // FILA 1: Input BTC -> Resultado MXN
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.charcoalBlack,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.currency_bitcoin,
                color: AppColors.primaryAmber,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _btcController, // <-- AQUÍ CONECTAMOS EL CABLE
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: 'Ej. 0.001',
                  hintStyle: TextStyle(color: AppColors.blueGray),
                  border: InputBorder.none,
                  suffixText: 'BTC',
                  suffixStyle: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(
                Icons.arrow_forward,
                color: AppColors.blueGray,
                size: 16,
              ),
            ),
            // Aquí se pinta el resultado reactivo
            Text(
              _mxnResult,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Divider(color: AppColors.deepNavy, thickness: 1),
        ),

        // FILA 2: Input SATS -> Resultado BTC
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.charcoalBlack,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.layers,
                color: AppColors.blueGray,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller:
                    _satsController, // <-- AQUÍ CONECTAMOS EL OTRO CABLE
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: 'Ej. 100000',
                  hintStyle: TextStyle(color: AppColors.blueGray),
                  border: InputBorder.none,
                  suffixText: 'SATS',
                  suffixStyle: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(
                Icons.arrow_forward,
                color: AppColors.blueGray,
                size: 16,
              ),
            ),
            // Aquí se pinta el resultado reactivo
            Text(
              _btcResult,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),
        const Center(
          child: Text(
            'Tasa de cambio actualizada en tiempo real',
            style: TextStyle(
              color: AppColors.blueGray,
              fontSize: 10,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
