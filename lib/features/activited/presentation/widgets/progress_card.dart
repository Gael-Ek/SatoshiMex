import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/models/models.dart';

class ProgressCard extends StatelessWidget {
  final int completedLessons;
  final int totalLessons;
  final int unitNumber;
  final String unitTitle;
  final String? unitImage;
  final RoadmapModel roadmap;
  final LessonModel? lesson;
  final int? unitId;

  const ProgressCard({
    super.key,
    required this.completedLessons,
    required this.totalLessons,
    required this.unitNumber,
    required this.unitTitle,
    this.unitImage,
    required this.roadmap,
    this.lesson,
    this.unitId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0E0B0B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          /// Imagen + overlay
          Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  image: DecorationImage(
                    image: NetworkImage("$unitImage"),

                    fit: BoxFit.cover,
                  ),
                ),
              ),

              /// gradiente oscuro
              Container(
                height: 120,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
              ),

              /// texto encima
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE59C48),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Unidad $unitNumber",
                        style: GoogleFonts.lexend(
                          color: const Color(0xFF091521),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      unitTitle,
                      style: GoogleFonts.lexend(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Progreso del módulo",
                      style: GoogleFonts.lexend(
                        color: Colors.blueGrey,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "$completedLessons / $totalLessons lecciones",
                      style: GoogleFonts.lexend(
                        color: const Color(0xFFE59C48),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (lesson == null || unitId == null) return;

                      context.push(
                        '/lesson',
                        extra: {
                          'lesson': lesson,
                          'unitId': unitId,
                          'roadmap': roadmap,
                        },
                      );
                    },

                    icon: const Icon(Icons.play_arrow),
                    label: Text(
                      "Continuar lección",
                      style: GoogleFonts.lexend(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE59C48),
                      foregroundColor: const Color(0xFF091521),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
