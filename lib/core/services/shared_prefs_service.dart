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

  // ── Racha diaria ───────────────────────────────────

  static const _streakKey = "user_streak";

  Future<void> saveStreak(Map<String, dynamic> streakJson) async {
    await prefs.setString(_streakKey, jsonEncode(streakJson));
  }

  Map<String, dynamic>? loadStreak() {
    final raw = prefs.getString(_streakKey);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> clearStreak() async {
    await prefs.remove(_streakKey);
  }

  //------- Billetera ------- //

  //Para saber si ya vio el tutorial
  static const _walletIntroKey = "has_seen_wallet_intro";

  //Para saber si ya creo la billetera
  static const _hasWalletKey = "has_wallet_created";

  //para guardar los datos de la tarjeta
  static const _walletDataKey = "wallet_data";

  //Funcion para guardar la tarjeta
  Future<void> saveWalletData(String balance, String address) async {
    await prefs.setString(
      _walletDataKey,
      jsonEncode({'balance': balance, 'address': address}),
    );
  }

  //Funcion para cargar la tarjeta
  Map<String, dynamic>? loadWalletData() {
    final raw = prefs.getString(_walletDataKey);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  // Verifica si el usuario ya vio el tutorial
  bool hasSeenWalletIntro() => prefs.getBool(_walletIntroKey) ?? false;

  // Establece que el usuario vio el tutorial
  Future<void> setWalletIntroSeen() async {
    await prefs.setBool(_walletIntroKey, true);
  }

  Future<void> clearIntro() async {
    await prefs.remove(_walletIntroKey);
    await prefs.remove(_walletDataKey);
    await prefs.remove(_hasWalletKey);
  }

  // Verifica si el usuario ya creo la billetera
  bool isWalletCreated() => prefs.getBool(_hasWalletKey) ?? false;

  // Establece que el usuario creo la billetera
  Future<void> setWalletCreated(bool value) async {
    await prefs.setBool(_hasWalletKey, value);
  }
}
