import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesService {
  final SharedPreferences prefs;

  SharedPreferencesService(this.prefs);

  //--- Onboarding --- //
  static const _onboardingKey = "seen_onboarding";

  Future<bool> isOnboardingSeen() async {
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> setOnboardingSeen() async {
    await prefs.setBool(_onboardingKey, true);
  }

  // ── Progreso del Roadmap ───────────────────────────────────
  // La key será algo como: "progress_roadmap_1"
  static String _progressKey(int roadmapId) => 'progress_roadmap_$roadmapId';

  Future<void> saveProgress(
    int roadmapId,
    Map<String, dynamic> progressJson,
  ) async {
    final key = _progressKey(roadmapId);
    await prefs.setString(key, jsonEncode(progressJson));
  }

  // Carga el progreso de un roadmap (null si no existe)
  Map<String, dynamic>? loadProgress(int roadmapId) {
    final key = _progressKey(roadmapId);
    final raw = prefs.getString(key);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  // Borra el progreso (útil para testing o reset de cuenta)
  Future<void> clearProgress(int roadmapId) async {
    await prefs.remove(_progressKey(roadmapId));
  }
}
