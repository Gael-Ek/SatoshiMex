class StreakModel {
  final int current;
  final int longest;
  final DateTime? lastDay;

  StreakModel({required this.current, required this.longest, this.lastDay});

  factory StreakModel.fromJson(Map<String, dynamic> json) {
    return StreakModel(
      current: json["current"],
      longest: json["longest"],
      lastDay: json["lastDay"] != null ? DateTime.parse(json["lastDay"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "current": current,
      "longest": longest,
      "lastDay": lastDay?.toIso8601String(),
    };
  }
}
