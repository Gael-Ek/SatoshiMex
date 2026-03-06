import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences prefs;

  SharedPreferencesService(this.prefs);

  static const _onboardingKey = "seen_onboarding";

  Future<bool> isOnboardingSeen() async {
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> setOnboardingSeen() async {
    await prefs.setBool(_onboardingKey, true);
  }
}
