// wallet_transaction_provider.dart
import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:satoshimex/core/providers/providers.dart';
import 'package:satoshimex/core/services/bitcoin_api_service.dart';

part 'wallet_transaction_provider.g.dart';

// ── Modelos ────────────────────────────────────────────────

class WalletTransaction {
  final String type;
  final double amountBtc;
  final String recipientName;
  final DateTime date;

  const WalletTransaction({
    required this.type,
    required this.amountBtc,
    required this.recipientName,
    required this.date,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> map) =>
      WalletTransaction(
        type: map['type'] as String,
        amountBtc: (map['amountBtc'] as num).toDouble(),
        recipientName: map['recipientName'] as String,
        date: DateTime.parse(map['date'] as String),
      );

  Map<String, dynamic> toJson() => {
    'type': type,
    'amountBtc': amountBtc,
    'recipientName': recipientName,
    'date': date.toIso8601String(),
  };
}

class WalletState {
  final double balanceBtc;
  final List<WalletTransaction> transactions;
  final double btcPriceMxn;

  const WalletState({
    required this.balanceBtc,
    required this.transactions,
    required this.btcPriceMxn,
  });

  WalletState copyWith({
    double? balanceBtc,
    List<WalletTransaction>? transactions,
    double? btcPriceMxn,
  }) => WalletState(
    balanceBtc: balanceBtc ?? this.balanceBtc,
    transactions: transactions ?? this.transactions,
    btcPriceMxn: btcPriceMxn ?? this.btcPriceMxn,
  );

  String formatBtc(double btc) =>
      btc.toStringAsFixed(8).replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');
}

// ── Provider ───────────────────────────────────────────────

@riverpod
class WalletTransaction_ extends _$WalletTransaction_ {
  static const _balanceKey = 'simulatedBalance';
  static const _txKey = 'walletTransactions';
  static const _recipientsKey = 'hascreatedRecipients';

  @override
  Future<WalletState> build() async {
    final service = ref.read(sharedPreferencesServiceProvider).requireValue;

    // Balance
    final raw = service.prefs.getString(_balanceKey) ?? '0.001 BTC';
    final balance = double.tryParse(raw.replaceAll(' BTC', '').trim()) ?? 0.0;

    // Transacciones
    final txList = service.prefs.getStringList(_txKey) ?? [];
    final transactions = txList.map((item) {
      return WalletTransaction.fromJson(
        jsonDecode(item) as Map<String, dynamic>,
      );
    }).toList();

    // Precio BTC
    final price = await BitcoinApiService.getBitcoinPriceInMXN();

    return WalletState(
      balanceBtc: balance,
      transactions: transactions,
      btcPriceMxn: price,
    );
  }

  // Busca el nombre del destinatario por dirección
  String findRecipientName(String address) {
    final service = ref.read(sharedPreferencesServiceProvider).requireValue;
    final list = service.prefs.getStringList(_recipientsKey) ?? [];
    for (final item in list) {
      try {
        final map = jsonDecode(item) as Map<String, dynamic>;
        if (map['address'] == address) return map['name'] as String;
      } catch (_) {}
    }
    return 'Desconocido';
  }

  // Ejecuta la transacción simulada
  Future<void> confirmSend({
    required String address,
    required double amount,
    required int feeSats,
    required double totalBtc,
  }) async {
    final service = ref.read(sharedPreferencesServiceProvider).requireValue;
    final current = state.value;
    if (current == null) return;

    // Nuevo balance
    double newBalance = current.balanceBtc - totalBtc;
    if (newBalance < 0) newBalance = 0.0;

    final formatted = newBalance
        .toStringAsFixed(8)
        .replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');

    await service.prefs.setString(_balanceKey, '$formatted BTC');

    // Nueva transacción
    final recipientName = findRecipientName(address);
    final newTx = WalletTransaction(
      type: 'ENVIADO',
      amountBtc: totalBtc,
      recipientName: recipientName,
      date: DateTime.now(),
    );

    final allTx = service.prefs.getStringList(_txKey) ?? [];
    allTx.insert(0, jsonEncode(newTx.toJson()));
    await service.prefs.setStringList(_txKey, allTx);

    // Simulación de red
    await Future.delayed(const Duration(seconds: 2));

    if (!ref.mounted) return;

    // Refrescar estado
    state = AsyncData(
      current.copyWith(
        balanceBtc: newBalance,
        transactions: [newTx, ...current.transactions],
      ),
    );
  }
}
