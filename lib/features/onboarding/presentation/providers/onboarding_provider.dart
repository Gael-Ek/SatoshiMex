import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:satoshimex/core/providers/providers.dart';
part 'onboarding_provider.g.dart';

@Riverpod(keepAlive: true)
class OnboardginShow extends _$OnboardginShow {
  @override
  Future<bool> build() async {
    final prefsService = await ref.read(
      sharedPreferencesServiceProvider.future,
    );
    return prefsService.isOnboardingSeen();
  }

  Future<void> completeOnboarding() async {
    final prefsService = await ref.read(
      sharedPreferencesServiceProvider.future,
    );

    await prefsService.setOnboardingSeen();

    state = const AsyncData(true);
  }
}
