import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:satoshimex/shared/models/models.dart';

part 'roadmap_providers.g.dart';

@Riverpod(keepAlive: true)
Future<RoadmapModel> getRoadmap(Ref ref) async {
  final jsonString = await rootBundle.loadString('assets/data/roadmap.json');

  final Map<String, dynamic> jsonMap = await Future.value(
    json.decode(jsonString),
  );

  return RoadmapModel.fromJson(jsonMap);
}
