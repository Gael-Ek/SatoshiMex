import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/features/roadmap/presentation/providers/progress_provider.dart';
import 'package:satoshimex/features/roadmap/presentation/screens/lesson_example.dart';
import 'package:satoshimex/features/roadmap/presentation/screens/lesson_explication_screen.dart';
import 'package:satoshimex/features/roadmap/presentation/screens/lesson_quiz_screen.dart';
import 'package:satoshimex/shared/models/models.dart';

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
  int currentIndex = 0;
  // Controlador para manejar el scroll manualmente
  final ScrollController _scrollController = ScrollController();

  final Map<int, String> _selectedOptions = {};
  final Map<int, bool> _results = {};

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Método para asegurar que el contenido empiece desde arriba al cambiar sección
  void _resetScroll() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  void _onPreviousStep() {
    if (currentIndex > 0) {
      _resetScroll();
      setState(() {
        currentIndex--;
      });
    }
  }

  void _onNextStep() {
    final notifier = ref.read(progressProvider(widget.roadmap).notifier);
    notifier.completeSection(widget.unitId, widget.lesson.id, currentIndex);

    if (currentIndex < widget.lesson.sections.length - 1) {
      _resetScroll();
      setState(() {
        currentIndex++;
      });
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
    final section = widget.lesson.sections[currentIndex];
    final progress = (currentIndex + 1) / widget.lesson.sections.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(section.title ?? widget.lesson.title),
        centerTitle: true,
      ),
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
                    'Sección ${currentIndex + 1} de ${widget.lesson.sections.length}',
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
                // El layoutBuilder evita saltos de altura durante la transición
                layoutBuilder:
                    (Widget? currentChild, List<Widget> previousChildren) {
                      return Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[...previousChildren, ?currentChild],
                      );
                    },
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(
                              0.1,
                              0,
                            ), // Desplazamiento sutil lateral
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                      child: child,
                    ),
                  );
                },
                // El ScrollView va DENTRO del switcher para que cada página
                // tenga su propia instancia de scroll independiente visualmente
                child: SingleChildScrollView(
                  key: ValueKey('scroll_section_$currentIndex'),
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  child: _buildSectionContent(section),
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
                  Expanded(child: _buildActionButton(section)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(SectionModel section) {
    final bool isQuiz = section.type == SectionType.quiz;
    final bool canContinue = !isQuiz || (_results.containsKey(currentIndex));

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
          currentIndex < widget.lesson.sections.length - 1
              ? 'CONTINUAR'
              : 'FINALIZAR',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSectionContent(SectionModel section) {
    // Es vital usar el currentIndex en la key para que el AnimatedSwitcher
    // reconozca que el contenido ha cambiado.
    final key = ValueKey('content_${section.type}_$currentIndex');

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
        return LessonQuiz(
          key: key,
          question: section.questions![0],
          selectedOption: _selectedOptions[currentIndex],
          isCorrect: _results[currentIndex],
          onAnswered: (option, correct) {
            setState(() {
              _selectedOptions[currentIndex] = option;
              _results[currentIndex] = correct;
            });
          },
        );
    }
  }
}
