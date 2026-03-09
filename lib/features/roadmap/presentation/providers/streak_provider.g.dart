// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StreakNotifier)
final streakProvider = StreakNotifierProvider._();

final class StreakNotifierProvider
    extends $NotifierProvider<StreakNotifier, StreakModel> {
  StreakNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'streakProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streakNotifierHash();

  @$internal
  @override
  StreakNotifier create() => StreakNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StreakModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StreakModel>(value),
    );
  }
}

String _$streakNotifierHash() => r'85154eca333d4504e0cc7c43db4b6dd854eebf57';

abstract class _$StreakNotifier extends $Notifier<StreakModel> {
  StreakModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<StreakModel, StreakModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StreakModel, StreakModel>,
              StreakModel,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
