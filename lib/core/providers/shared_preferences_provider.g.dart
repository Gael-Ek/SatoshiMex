// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_preferences_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sharedPreferencesService)
final sharedPreferencesServiceProvider = SharedPreferencesServiceProvider._();

final class SharedPreferencesServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<SharedPreferencesService>,
          SharedPreferencesService,
          FutureOr<SharedPreferencesService>
        >
    with
        $FutureModifier<SharedPreferencesService>,
        $FutureProvider<SharedPreferencesService> {
  SharedPreferencesServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesServiceHash();

  @$internal
  @override
  $FutureProviderElement<SharedPreferencesService> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SharedPreferencesService> create(Ref ref) {
    return sharedPreferencesService(ref);
  }
}

String _$sharedPreferencesServiceHash() =>
    r'd7e229e6f9225959d6d79809c2eae189a9a0f00c';
