// features/wallet/providers/bitcoin_price_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:satoshimex/core/services/bitcoin_api_service.dart';

part 'bitcoin_price_provider.g.dart';

@riverpod
Future<double> bitcoinPrice(Ref ref) async {
  try {
    // Intentamos obtener el precio real
    final price = await BitcoinApiService.getBitcoinPriceInMXN();
    return price > 0
        ? price
        : 1000000.0; // Valor de respaldo si la API devuelve 0
  } catch (e) {
    // Si no hay internet o falla la API, devolvemos un valor base
    return 1000000.0;
  }
}
