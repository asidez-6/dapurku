import 'package:flutter/material.dart';

import 'pages/main_page.dart';
import 'pages/meal_detail_page.dart';
import 'pages/meal_list_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const DapurkuApp());
}

class DapurkuApp extends StatelessWidget {
  const DapurkuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dapurku',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // Semua halaman didaftarkan di sini (Named Route).
      initialRoute: MainPage.routeName,
      routes: {
        MainPage.routeName: (context) => const MainPage(),
        MealListPage.routeName: (context) => const MealListPage(),
        MealDetailPage.routeName: (context) => const MealDetailPage(),
      },
    );
  }
}
