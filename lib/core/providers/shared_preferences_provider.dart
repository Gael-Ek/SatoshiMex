import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:satoshimex/core/services/shared_prefs_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences_provider.g.dart';

@riverpod
Future<SharedPreferencesService> sharedPreferencesService(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  return SharedPreferencesService(prefs);
}
