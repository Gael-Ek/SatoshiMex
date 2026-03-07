import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:satoshimex/features/roadmap/presentation/providers/progress_provider.dart';
import 'package:satoshimex/shared/models/models.dart';

class LessonScreen extends ConsumerStatefulWidget {
  final LessonModel lesson;
  final int unitId;
  final RoadmapModel roadmap; // Necesario para el progressProvider family

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

  void _onNextStep() {
    final notifier = ref.read(progressProvider(widget.roadmap).notifier);

    // 1. Marcar sección actual como completada
    notifier.completeSection(widget.unitId, widget.lesson.id, currentIndex);

    // 2. Lógica de navegación interna
    if (currentIndex < widget.lesson.sections.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      // Si es la última sección, regresamos al Roadmap
      context.pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('¡Lección completada!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final section = widget.lesson.sections[currentIndex];
    final progress = (currentIndex + 1) / widget.lesson.sections.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        // Botón de retroceso manual por si quieren salir sin terminar
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Barra de progreso visual
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
              const SizedBox(height: 24),

              // Contenido dinámico según el tipo de sección
              Expanded(
                child: SingleChildScrollView(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildSectionContent(section),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Botón de acción principal
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _onNextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    currentIndex < widget.lesson.sections.length - 1
                        ? 'CONTINUAR'
                        : 'FINALIZAR LECCIÓN',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionContent(SectionModel section) {
    // Usamos el ID del currentIndex como Key para el AnimatedSwitcher
    switch (section.type) {
      case SectionType.explanation:
        return Column(
          key: ValueKey(currentIndex),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Concepto Clave", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(
              section.content!,
              style: const TextStyle(fontSize: 20, height: 1.5),
            ),
          ],
        );

      case SectionType.example:
        return Container(
          key: ValueKey(currentIndex),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.lightbulb, color: Colors.amber),
                  SizedBox(width: 8),
                  Text(
                    'Ejemplo Práctico',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                section.content!,
                style: const TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        );

      case SectionType.quiz:
        return Column(
          key: ValueKey(currentIndex),
          children: section.questions!.map((q) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  q.question,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...q.options!.map(
                  (option) => Card(
                    child: RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue:
                          null, // Aquí podrías añadir lógica de selección local
                      onChanged: (val) {
                        // Lógica de validación de respuesta
                      },
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        );
    }
  }
}
