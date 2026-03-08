// lesson_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/features/roadmap/presentation/providers/progress_provider.dart';
import 'package:satoshimex/features/roadmap/presentation/screens/lesson_example.dart';
import 'package:satoshimex/features/roadmap/presentation/screens/lesson_explication_screen.dart';
import 'package:satoshimex/features/roadmap/presentation/screens/lesson_quiz_screen.dart';
import 'package:satoshimex/shared/models/models.dart';

// Representa un paso "aplanado": puede ser una sección entera (explanation/example)
// o una sola pregunta de quiz con su índice dentro de la sección.
class _FlatStep {
  final SectionModel section;
  final int sectionIndex;
  final int? questionIndex; // null si no es quiz

  const _FlatStep({
    required this.section,
    required this.sectionIndex,
    this.questionIndex,
  });

  bool get isQuiz => questionIndex != null;
}

class LessonScreen extends ConsumerStatefulWidget {
  final LessonModel lesson;
  final int unitId;
  final RoadmapModel roadmap;

  const LessonScreen({
    super.key,
    required this.lesson,
    required this.unitId,
    required this.roadmap,
  });

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  late final List<_FlatStep> _flatSteps;
  int currentIndex = 0;
  final ScrollController _scrollController = ScrollController();

  // Key: "sectionIndex_questionIndex" → opción seleccionada
  final Map<String, String> _selectedOptions = {};
  // Key: "sectionIndex_questionIndex" → resultado
  final Map<String, bool> _results = {};

  @override
  void initState() {
    super.initState();
    _flatSteps = _buildFlatSteps();
  }

  List<_FlatStep> _buildFlatSteps() {
    final steps = <_FlatStep>[];
    for (var i = 0; i < widget.lesson.sections.length; i++) {
      final section = widget.lesson.sections[i];
      if (section.type == SectionType.quiz && section.questions != null) {
        // Una entrada por cada pregunta del quiz
        for (var q = 0; q < section.questions!.length; q++) {
          steps.add(
            _FlatStep(section: section, sectionIndex: i, questionIndex: q),
          );
        }
      } else {
        steps.add(_FlatStep(section: section, sectionIndex: i));
      }
    }
    return steps;
  }

  String _quizKey(int sectionIndex, int questionIndex) =>
      '${sectionIndex}_$questionIndex';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _resetScroll() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  void _onPreviousStep() {
    if (currentIndex > 0) {
      _resetScroll();
      setState(() => currentIndex--);
    }
  }

  void _onNextStep() {
    final step = _flatSteps[currentIndex];
    final notifier = ref.read(progressProvider(widget.roadmap).notifier);

    // Solo notifica progreso al pasar la última pregunta de una sección quiz
    // o al pasar secciones normales.
    final isLastQuestionOfSection =
        step.isQuiz &&
        step.questionIndex == (step.section.questions!.length - 1);

    if (!step.isQuiz || isLastQuestionOfSection) {
      notifier.completeSection(
        widget.unitId,
        widget.lesson.id,
        step.sectionIndex,
      );
    }

    if (currentIndex < _flatSteps.length - 1) {
      _resetScroll();
      setState(() => currentIndex++);
    } else {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Lección completada!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = _flatSteps[currentIndex];
    final section = step.section;
    final progress = (currentIndex + 1) / _flatSteps.length;

    // Título dinámico: si es quiz muestra "Pregunta X de Y"
    String appBarTitle;
    if (step.isQuiz) {
      final totalQuestions = section.questions!.length;
      appBarTitle = 'Pregunta ${step.questionIndex! + 1} de $totalQuestions';
    } else {
      appBarTitle = section.title ?? widget.lesson.title;
    }

    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            // BARRA DE PROGRESO SUPERIOR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Paso ${currentIndex + 1} de ${_flatSteps.length}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryAmber,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.white.withValues(alpha: .05),
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),

            // CONTENIDO ANIMADO
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                layoutBuilder: (currentChild, previousChildren) => Stack(
                  alignment: Alignment.topCenter,
                  children: [...previousChildren, ?currentChild],
                ),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0.1, 0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                    child: child,
                  ),
                ),
                child: SingleChildScrollView(
                  key: ValueKey('scroll_step_$currentIndex'),
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  child: _buildStepContent(step),
                ),
              ),
            ),

            // ÁREA DE BOTONES
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (currentIndex > 0) ...[
                    SizedBox(
                      height: 55,
                      width: 55,
                      child: OutlinedButton(
                        onPressed: _onPreviousStep,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Colors.orange,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.orange,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(child: _buildActionButton(step)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(_FlatStep step) {
    bool canContinue = true;

    if (step.isQuiz) {
      final key = _quizKey(step.sectionIndex, step.questionIndex!);
      canContinue = _results.containsKey(key);
    }

    return SizedBox(
      height: 55,
      child: ElevatedButton(
        onPressed: canContinue ? _onNextStep : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[800],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          currentIndex < _flatSteps.length - 1 ? 'CONTINUAR' : 'FINALIZAR',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildStepContent(_FlatStep step) {
    final section = step.section;
    final key = ValueKey(
      'content_${step.sectionIndex}_${step.questionIndex ?? "none"}',
    );

    switch (section.type) {
      case SectionType.explanation:
        return LessonExplanation(
          key: key,
          content: section.content!,
          imageUrl: section.imageUrl,
          title: section.title,
          subtitle: section.subtitle,
        );

      case SectionType.example:
        return LessonExample(
          key: key,
          content: section.content!,
          imageUrl: section.imageUrl,
          title: section.title,
          subtitle: section.subtitle,
        );

      case SectionType.quiz:
        final qIndex = step.questionIndex!;
        final question = section.questions![qIndex];
        final mapKey = _quizKey(step.sectionIndex, qIndex);

        return LessonQuiz(
          key: key,
          question: question,
          selectedOption: _selectedOptions[mapKey],
          isCorrect: _results[mapKey],
          onAnswered: (option, correct) {
            setState(() {
              _selectedOptions[mapKey] = option;
              _results[mapKey] = correct;
            });
          },
        );
    }
  }
}
