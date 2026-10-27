import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Judul bagian, dengan tombol aksi opsional di sebelah kanan.
class SectionTitle extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  const SectionTitle({
    super.key,
    required this.title,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 8, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
          ),
          if (onAction != null)
            TextButton.icon(
              onPressed: onAction,
              icon: Icon(actionIcon ?? Icons.chevron_right, size: 18),
              label: Text(actionLabel ?? 'Lihat'),
            ),
        ],
      ),
    );
  }
}
