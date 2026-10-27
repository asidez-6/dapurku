import 'package:flutter/material.dart';

/// Warna aplikasi dikumpulkan di satu tempat supaya tampilan konsisten.
/// Tema hangat ala dapur: oranye labu, krem, dan cokelat.
class AppColors {
  static const Color primary = Color(0xFFD35400); // oranye labu (header, tombol)
  static const Color primaryDark = Color(0xFFA04000);
  static const Color background = Color(0xFFFFF8F0); // krem
  static const Color card = Colors.white;
  static const Color accent = Color(0xFF2E7D32); // hijau daun (sorotan kecil)
  static const Color textMain = Color(0xFF3E2723); // cokelat tua
  static const Color textMuted = Color(0xFF8D6E63); // cokelat muda
  static const Color chip = Color(0xFFFFE0CC); // latar label
  static const Color placeholder = Color(0xFFF3E5DA); // kotak gambar kosong
  static const Color overlay = Color(0x99000000); // hitam transparan 60%
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.background,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}
