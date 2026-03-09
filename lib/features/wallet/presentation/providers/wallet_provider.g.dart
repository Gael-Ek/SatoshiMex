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

String _$walletStateHash() => r'99e2c08206f9672c38ced2e9d21e4c8d8307110a';

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

@ProviderFor(walletData)
final walletDataProvider = WalletDataProvider._();

final class WalletDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>?>,
          Map<String, dynamic>?,
          FutureOr<Map<String, dynamic>?>
        >
    with
        $FutureModifier<Map<String, dynamic>?>,
        $FutureProvider<Map<String, dynamic>?> {
  WalletDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletDataHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>?> create(Ref ref) {
    return walletData(ref);
  }
}

String _$walletDataHash() => r'9a87c2174a145706f0bcf8e787811f9101fac68e';
