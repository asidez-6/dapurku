import 'package:flutter/material.dart';

import '../models/meal_category.dart';
import '../theme/app_theme.dart';
import 'net_image.dart';

/// Kartu kategori: gambar kategori dan namanya.
class CategoryCard extends StatelessWidget {
  final MealCategory category;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.card,
      elevation: 1.5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: NetImage(
                  url: category.thumbnail,
                  fit: BoxFit.contain,
                  radius: 0,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
