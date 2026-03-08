// wallet_recipients_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:satoshimex/core/providers/providers.dart';

part 'wallet_recipients_provider.g.dart';

@riverpod
class WalletRecipients extends _$WalletRecipients {
  @override
  List<String> build() {
    final service = ref.read(sharedPreferencesServiceProvider).requireValue;
    return service.loadWalletRecipients();
  }

  Future<void> addRecipient(String recipient) async {
    final service = ref.read(sharedPreferencesServiceProvider).requireValue;
    await service.addWalletRecipient(recipient);

    if (!ref.mounted) return; // ← verifica antes de usar ref o state

    state = service.loadWalletRecipients();
  }

  bool get hasRecipients => state.isNotEmpty;
}
