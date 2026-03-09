import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

import '../../../../shared/models/models.dart';

class UnitHeaderTile extends StatelessWidget {
  final UnitModel unit;
  const UnitHeaderTile({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.deepNavy,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.slateBlueGray),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryAmber.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryAmber),
              ),
              child: Text(
                'UNIDAD ${unit.id}',
                style: const TextStyle(
                  color: AppColors.primaryAmber,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                unit.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
