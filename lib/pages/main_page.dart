import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'about_page.dart';
import 'area_page.dart';
import 'home_page.dart';

/// Halaman induk berisi BottomNavigationBar dengan tiga tab.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static const routeName = '/';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // IndexedStack menyimpan semua tab, jadi data dan posisi scroll
  // tidak hilang saat berpindah tab.
  final List<Widget> _tabs = const [
    HomePage(),
    AreaPage(),
    AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.white,
        indicatorColor: AppColors.chip,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.primary),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.public_outlined),
            selectedIcon: Icon(Icons.public, color: AppColors.primary),
            label: 'Negara',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info, color: AppColors.primary),
            label: 'Tentang',
          ),
        ],
      ),
    );
  }
}
