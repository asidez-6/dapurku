import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Gambar dari internet dengan tampilan cadangan.
/// Saat gambar dimuat tampil indikator kecil, dan kalau gagal dimuat
/// tampil kotak dengan ikon, bukan error.
class NetImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final double radius;
  final BoxFit fit;
  final IconData fallbackIcon;

  const NetImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.radius = 12,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: url.isEmpty
          ? _placeholder(Icon(fallbackIcon, color: AppColors.textMuted))
          : Image.network(
              url,
              width: width,
              height: height,
              fit: fit,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return _placeholder(
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) =>
                  _placeholder(Icon(fallbackIcon, color: AppColors.textMuted)),
            ),
    );
  }

  Widget _placeholder(Widget child) {
    return Container(
      width: width,
      height: height,
      color: AppColors.placeholder,
      alignment: Alignment.center,
      child: child,
    );
  }
}
