import 'package:flutter/material.dart';

import '../models/meal_summary.dart';
import '../theme/app_theme.dart';
import 'net_image.dart';

/// Kartu resep untuk grid: foto di atas, nama resep di bawah.
class MealCard extends StatelessWidget {
  final MealSummary meal;
  final VoidCallback onTap;

  const MealCard({super.key, required this.meal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final subtitle = [meal.category, meal.area]
        .whereType<String>()
        .where((t) => t.isNotEmpty)
        .join(' • ');

    return Card(
      color: AppColors.card,
      elevation: 1.5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Hero(
                tag: 'meal-${meal.id}',
                child: NetImage(url: meal.thumbnail, radius: 0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                      height: 1.2,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
