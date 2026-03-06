import 'package:satoshimex/shared/models/models.dart';

class RoadmapModel {
  final String title;
  final List<UnitModel> units;

  RoadmapModel({required this.title, required this.units});

  factory RoadmapModel.fromJson(Map<String, dynamic> json) {
    return RoadmapModel(
      title: json['roadmap_title'],
      units: List<UnitModel>.from(
        json['units'].map((x) => UnitModel.fromJson(x)),
      ),
    );
  }
}
