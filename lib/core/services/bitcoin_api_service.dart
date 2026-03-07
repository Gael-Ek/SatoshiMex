import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class BitcoinApiService {
  // Función estática para llamarla desde cualquier lado sin instanciar
  static Future<double> getBitcoinPriceInMXN() async {
    try {
      // 1. El endpoint exacto de CoinGecko para BTC a MXN
      final url = Uri.parse(
        'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=mxn',
      );

      // 2. Hacemos la petición a internet
      final response = await http.get(url);

      // 3. Si el servidor responde un "OK" (200)
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // La API devuelve esto: {"bitcoin":{"mxn": 1150000.0}}
        // Así que extraemos ese número exacto:
        return data['bitcoin']['mxn'].toDouble();
      } else {
        debugPrint('Error en la API: ${response.statusCode}');
        return 1350000.0; // Precio de respaldo (MVP)
      }
    } catch (e) {
      // Si el usuario no tiene internet, entramos aquí
      debugPrint('Error de conexión (Sin internet): $e');
      return 1350000.0; // Precio de respaldo para que la app no truene en el Hackathon
    }
  }
}
