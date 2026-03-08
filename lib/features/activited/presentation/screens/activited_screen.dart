import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/core/widgets/button.dart';
import 'package:satoshimex/features/activited/presentation/widgets/ai_card.dart';
import 'package:satoshimex/features/activited/presentation/widgets/progress_card.dart';
import 'package:satoshimex/features/activited/presentation/widgets/streak_card.dart';
import 'package:satoshimex/features/roadmap/presentation/providers/roadmap_providers.dart';
import 'package:satoshimex/features/roadmap/presentation/providers/roadmap_summary_provider.dart';
import 'package:satoshimex/features/roadmap/presentation/providers/streak_provider.dart';
import 'package:satoshimex/features/wallet/presentation/providers/wallet_provider.dart';

class ActivitedScreen extends ConsumerWidget {
  final void Function(int)? onNavigate;
  const ActivitedScreen({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider);
    final roadmapAsync = ref.watch(getRoadmapProvider);

    return roadmapAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(err.toString())),
      ),
      data: (roadmap) {
        final summary = ref.watch(roadmapSummaryProvider(roadmap));

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Mi Actividad',
              style: GoogleFonts.lexend(color: Colors.white),
            ),
          ),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              /// -------------------------
              /// CARD RACHA
              /// -------------------------
              StreakCard(streak: streak.current),

              const SizedBox(height: 30),

              /// -------------------------
              /// CONTINUAR APRENDIENDO
              /// -------------------------
              Row(
                spacing: 10,
                children: [
                  Icon(Icons.school, color: AppColors.primaryAmber, size: 32),
                  Text(
                    "Continuar aprendiendo",
                    style: GoogleFonts.lexend(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              ProgressCard(
                completedLessons: summary.completedLessons,
                totalLessons: summary.totalLessons,
                unitNumber: summary.currentUnit.id,
                unitTitle: summary.currentUnit.title,
                unitImage: summary.currentUnit.image,
                roadmap: roadmap,
                lesson: summary.nextLesson,
                unitId: summary.nextUnitId,
              ),

              const SizedBox(height: 16),

              ActivityAiCard(
                onTap: () {
                  onNavigate?.call(3);
                },
              ),

              const SizedBox(height: 16),
              CustomButton(
                text: "Eliminar datos de onboarding wallet",
                onPressed: () {
                  ref.read(walletStateProvider.notifier).clearIntro();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
