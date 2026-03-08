// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WalletState)
final walletStateProvider = WalletStateProvider._();

final class WalletStateProvider
    extends $AsyncNotifierProvider<WalletState, WalletStatus> {
  WalletStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletStateHash();

  @$internal
  @override
  WalletState create() => WalletState();
}

String _$walletStateHash() => r'6600ef0dfaf2ab71d489e3d356ded9f1afb8f7d4';

abstract class _$WalletState extends $AsyncNotifier<WalletStatus> {
  FutureOr<WalletStatus> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<WalletStatus>, WalletStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<WalletStatus>, WalletStatus>,
              AsyncValue<WalletStatus>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
