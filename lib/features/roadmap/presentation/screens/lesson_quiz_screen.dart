import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/shared/models/models.dart';

class LessonQuiz extends StatelessWidget {
  final QuestionsModel question;
  final String? selectedOption;
  final bool? isCorrect;
  final Function(String, bool) onAnswered;

  const LessonQuiz({
    super.key,
    required this.question,
    required this.selectedOption,
    required this.onAnswered,
    this.isCorrect,
  });

  void _showFeedback(BuildContext context, bool correct) {
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      context: context,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        // Agregamos el decorado con bordes redondeados y el color que elegiste
        decoration: BoxDecoration(
          color: correct ? Colors.green[50] : Colors.red[50],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  correct ? Icons.check_circle : Icons.error,
                  color: correct ? Colors.green : Colors.red,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  correct ? "¡Excelente!" : "Respuesta Incorrecta",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: correct ? Colors.green[800] : Colors.red[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Aquí usamos el campo 'feedback' o uno genérico si no existe
            correct
                ? Text(
                    "Tu respuesta es correcta. Haz ganado conocimiento",
                    style: const TextStyle(fontSize: 17, color: Colors.black87),
                  )
                : Text(
                    "Nota: ${question.feedback}",
                    style: const TextStyle(fontSize: 17, color: Colors.black87),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- SECCIÓN DE LA PREGUNTA (BURBUJA ANIMADA) ---
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primaryAmber,
              child: Icon(
                Icons.currency_bitcoin,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut, // Efecto de rebote suave
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    alignment: Alignment.topLeft,
                    child: child,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColors.deepNavy,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    question.question,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // --- OPCIONES DE RESPUESTA ---
        ...question.options!.map((option) {
          final isThisSelected = selectedOption == option;

          Color bgColor = AppColors.deepNavy.withValues(alpha: .5);
          Color borderColor = AppColors.blueGray.withValues(alpha: .3);
          Color textColor = Colors.white70;

          if (isThisSelected) {
            if (isCorrect == true) {
              bgColor = Colors.green.withValues(alpha: .2);
              borderColor = Colors.greenAccent;
              textColor = Colors.greenAccent;
            } else {
              bgColor = Colors.red.withValues(alpha: .2);
              borderColor = Colors.redAccent;
              textColor = Colors.redAccent;
            }
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: (isCorrect != null)
                    ? null
                    : () {
                        final correct = (option == question.answer);
                        onAnswered(option, correct);
                        _showFeedback(context, correct);
                      },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isThisSelected
                                ? borderColor
                                : AppColors.blueGray,
                            width: 2,
                          ),
                          color: isThisSelected
                              ? borderColor
                              : Colors.transparent,
                        ),
                        child: isThisSelected
                            ? Icon(
                                isCorrect! ? Icons.check : Icons.close,
                                size: 16,
                                color: AppColors.blueDark,
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: isThisSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
