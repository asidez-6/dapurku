import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../theme/app_theme.dart';

/// Tab Tentang: penjelasan singkat aplikasi, sumber data, dan pembuat.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SizedBox(height: 8),
          Center(
            child: CircleAvatar(
              radius: 42,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.soup_kitchen, size: 42, color: Colors.white),
            ),
          ),
          SizedBox(height: 12),
          Center(
            child: Text(
              'Dapurku',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
          ),
          Center(
            child: Text('Versi 1.0.0', style: TextStyle(color: AppColors.textMuted)),
          ),
          SizedBox(height: 20),
          Card(
            color: AppColors.card,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Dapurku membantu kamu mencari ide masakan dari berbagai '
                'negara. Cari resep berdasarkan nama, jelajahi per kategori '
                'atau asal negara, lalu lihat bahan, takaran, dan langkah '
                'memasaknya.',
                textAlign: TextAlign.justify,
                style: TextStyle(height: 1.5, color: AppColors.textMain),
              ),
            ),
          ),
          Card(
            color: AppColors.card,
            child: ListTile(
              leading: Icon(Icons.cloud_outlined, color: AppColors.primary),
              title: Text('Sumber data'),
              subtitle: Text('TheMealDB API\n${ApiService.baseUrl}'),
              isThreeLine: true,
            ),
          ),
          Card(
            color: AppColors.card,
            child: ListTile(
              leading: Icon(Icons.person_outline, color: AppColors.primary),
              title: Text('Dibuat oleh'),
              subtitle: Text('Muhammad Ihsan Anshorudin\n240605110199'),
              isThreeLine: true,
            ),
          ),
        ],
      ),
    );
  }
}
