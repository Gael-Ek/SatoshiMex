// features/wallet/providers/wallet_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:satoshimex/core/providers/providers.dart';
import 'package:satoshimex/shared/models/wallet/wallet.dart';

part 'wallet_provider.g.dart';

enum WalletStatus { needsIntro, needsCreation, ready }

@riverpod
class WalletState extends _$WalletState {
  @override
  FutureOr<WalletStatus> build() async {
    // Obtenemos el servicio
    final service = await ref.watch(sharedPreferencesServiceProvider.future);

    // ¿Vio el tutorial?
    if (!service.hasSeenWalletIntro()) {
      return WalletStatus.needsIntro;
    }

    //¿Ya creo la billetera?
    if (!service.isWalletCreated()) {
      return WalletStatus.needsCreation;
    }

    //Todo listo
    return WalletStatus.ready;
  }

  // Método para cuando termina el tutorial
  Future<void> markIntroAsSeen() async {
    final service = await ref.read(sharedPreferencesServiceProvider.future);
    await service.setWalletIntroSeen();
    ref.invalidateSelf(); // Esto refresca el build() y pasará a 'needsCreation'
  }

  // Método para cuando termina de crear la billetera
  Future<void> completeWalletSetup(WalletModel wallet) async {
    final service = await ref.read(sharedPreferencesServiceProvider.future);
    await service.saveWalletData(wallet.balance, wallet.address);
    await service.setWalletCreated(true);
    state = const AsyncData(WalletStatus.ready);
  }

  //Eliminar datos de intro
  Future<void> clearIntro() async {
    final service = await ref.read(sharedPreferencesServiceProvider.future);
    await service.clearIntro();
  }
}
