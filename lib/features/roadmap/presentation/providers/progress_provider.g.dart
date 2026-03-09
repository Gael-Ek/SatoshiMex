// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProgressNotifier)
final progressProvider = ProgressNotifierFamily._();

final class ProgressNotifierProvider
    extends $NotifierProvider<ProgressNotifier, List<UnitProgress>> {
  ProgressNotifierProvider._({
    required ProgressNotifierFamily super.from,
    required RoadmapModel super.argument,
  }) : super(
         retry: null,
         name: r'progressProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$progressNotifierHash();

  @override
  String toString() {
    return r'progressProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProgressNotifier create() => ProgressNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<UnitProgress> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<UnitProgress>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProgressNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$progressNotifierHash() => r'21e4ba74a447d9df906b6098a90c4b15323797d6';

final class ProgressNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          ProgressNotifier,
          List<UnitProgress>,
          List<UnitProgress>,
          List<UnitProgress>,
          RoadmapModel
        > {
  ProgressNotifierFamily._()
    : super(
        retry: null,
        name: r'progressProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProgressNotifierProvider call(RoadmapModel roadmap) =>
      ProgressNotifierProvider._(argument: roadmap, from: this);

  @override
  String toString() => r'progressProvider';
}

abstract class _$ProgressNotifier extends $Notifier<List<UnitProgress>> {
  late final _$args = ref.$arg as RoadmapModel;
  RoadmapModel get roadmap => _$args;

  List<UnitProgress> build(RoadmapModel roadmap);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<UnitProgress>, List<UnitProgress>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<UnitProgress>, List<UnitProgress>>,
              List<UnitProgress>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
