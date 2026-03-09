// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_transaction_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WalletTransaction_)
final walletTransaction_Provider = WalletTransaction_Provider._();

final class WalletTransaction_Provider
    extends $AsyncNotifierProvider<WalletTransaction_, WalletState> {
  WalletTransaction_Provider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletTransaction_Provider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletTransaction_Hash();

  @$internal
  @override
  WalletTransaction_ create() => WalletTransaction_();
}

String _$walletTransaction_Hash() =>
    r'd5c93e39e7b95ad086c4dbde91ae985b507316ba';

abstract class _$WalletTransaction_ extends $AsyncNotifier<WalletState> {
  FutureOr<WalletState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<WalletState>, WalletState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<WalletState>, WalletState>,
              AsyncValue<WalletState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
