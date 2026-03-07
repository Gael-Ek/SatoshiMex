import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:satoshimex/core/providers/providers.dart';
import 'package:satoshimex/core/utils/roadmap/normalize_date.dart';

import '../../../../shared/models/models.dart';

part 'streak_provider.g.dart';

@riverpod
class StreakNotifier extends _$StreakNotifier {
  @override
  StreakModel build() {
    _load();
    return StreakModel(current: 0, longest: 0);
  }

  Future<void> _load() async {
    final prefs = await ref.read(sharedPreferencesServiceProvider.future);

    final data = prefs.loadStreak();

    if (data != null) {
      state = StreakModel.fromJson(data);
    }
  }

  Future<void> updateStreak() async {
    final today = normalizeDate(DateTime.now());
    final last = state.lastDay != null ? normalizeDate(state.lastDay!) : null;

    int current = state.current;

    if (last != null) {
      final difference = today.difference(last).inDays;

      if (difference == 1) {
        current += 1;
      } else if (difference > 1) {
        current = 1;
      } else {
        return;
      }
    } else {
      current = 1;
    }

    final longest = current > state.longest ? current : state.longest;

    state = StreakModel(current: current, longest: longest, lastDay: today);

    final prefs = await ref.read(sharedPreferencesServiceProvider.future);

    await prefs.saveStreak(state.toJson());
  }
}
