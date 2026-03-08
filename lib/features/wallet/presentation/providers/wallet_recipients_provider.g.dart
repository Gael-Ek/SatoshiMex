// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_recipients_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WalletRecipients)
final walletRecipientsProvider = WalletRecipientsProvider._();

final class WalletRecipientsProvider
    extends $NotifierProvider<WalletRecipients, List<String>> {
  WalletRecipientsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletRecipientsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletRecipientsHash();

  @$internal
  @override
  WalletRecipients create() => WalletRecipients();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$walletRecipientsHash() => r'2b8633b8c606a3f127b9293f6d4246f19ca0ff5b';

abstract class _$WalletRecipients extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
