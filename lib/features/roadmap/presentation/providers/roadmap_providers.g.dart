// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roadmap_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getRoadmap)
final getRoadmapProvider = GetRoadmapProvider._();

final class GetRoadmapProvider
    extends
        $FunctionalProvider<
          AsyncValue<RoadmapModel>,
          RoadmapModel,
          FutureOr<RoadmapModel>
        >
    with $FutureModifier<RoadmapModel>, $FutureProvider<RoadmapModel> {
  GetRoadmapProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getRoadmapProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getRoadmapHash();

  @$internal
  @override
  $FutureProviderElement<RoadmapModel> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RoadmapModel> create(Ref ref) {
    return getRoadmap(ref);
  }
}

String _$getRoadmapHash() => r'46d9e1658e39b44f2d706bec57ac83151ee00fee';
