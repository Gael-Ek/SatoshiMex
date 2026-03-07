// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roadmap_summary_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(roadmapSummary)
final roadmapSummaryProvider = RoadmapSummaryFamily._();

final class RoadmapSummaryProvider
    extends $FunctionalProvider<RoadmapSummary, RoadmapSummary, RoadmapSummary>
    with $Provider<RoadmapSummary> {
  RoadmapSummaryProvider._({
    required RoadmapSummaryFamily super.from,
    required RoadmapModel super.argument,
  }) : super(
         retry: null,
         name: r'roadmapSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$roadmapSummaryHash();

  @override
  String toString() {
    return r'roadmapSummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<RoadmapSummary> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RoadmapSummary create(Ref ref) {
    final argument = this.argument as RoadmapModel;
    return roadmapSummary(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RoadmapSummary value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RoadmapSummary>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RoadmapSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$roadmapSummaryHash() => r'f2ebdaf63de08bfbf16f4f30722754ef2f8ef502';

final class RoadmapSummaryFamily extends $Family
    with $FunctionalFamilyOverride<RoadmapSummary, RoadmapModel> {
  RoadmapSummaryFamily._()
    : super(
        retry: null,
        name: r'roadmapSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RoadmapSummaryProvider call(RoadmapModel roadmap) =>
      RoadmapSummaryProvider._(argument: roadmap, from: this);

  @override
  String toString() => r'roadmapSummaryProvider';
}
