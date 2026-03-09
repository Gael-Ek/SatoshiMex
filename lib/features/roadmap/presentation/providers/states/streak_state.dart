class StreakState {
  final int current;
  final int longest;
  final DateTime? lastDay;

  const StreakState({
    required this.current,
    required this.longest,
    this.lastDay,
  });

  StreakState copyWith({int? current, int? longest, DateTime? lastDay}) {
    return StreakState(
      current: current ?? this.current,
      longest: longest ?? this.longest,
      lastDay: lastDay ?? this.lastDay,
    );
  }
}
