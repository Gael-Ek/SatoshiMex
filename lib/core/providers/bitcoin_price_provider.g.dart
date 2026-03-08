// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bitcoin_price_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bitcoinPrice)
final bitcoinPriceProvider = BitcoinPriceProvider._();

final class BitcoinPriceProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  BitcoinPriceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bitcoinPriceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bitcoinPriceHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return bitcoinPrice(ref);
  }
}

String _$bitcoinPriceHash() => r'76147865c85f607d305122e102a82a9a407c78c3';
