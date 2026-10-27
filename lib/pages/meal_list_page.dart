import 'package:flutter/material.dart';

import '../models/meal_category.dart';
import '../models/meal_summary.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/area_info.dart';
import '../widgets/meal_card.dart';
import '../widgets/state_views.dart';
import 'meal_detail_page.dart';

enum MealListType { category, area, search }

/// Data yang dikirim ke halaman daftar resep lewat Navigator (arguments).
class MealListArgs {
  final MealListType type;
  final String value; // nama kategori, nama negara, atau kata pencarian
  final String title;
  final String? description;

  const MealListArgs._(this.type, this.value, this.title, [this.description]);

  factory MealListArgs.category(MealCategory category) => MealListArgs._(
        MealListType.category,
        category.name,
        category.name,
        category.description,
      );

  factory MealListArgs.area(String area) {
    final info = AreaInfo.of(area);
    return MealListArgs._(
        MealListType.area, area, 'Masakan ${info.name} ${info.flag}');
  }

  factory MealListArgs.search(String keyword) =>
      MealListArgs._(MealListType.search, keyword, 'Hasil "$keyword"');
}

/// Halaman daftar resep berdasarkan kategori, asal negara, atau pencarian.
class MealListPage extends StatefulWidget {
  const MealListPage({super.key});

  static const routeName = '/meals';

  @override
  State<MealListPage> createState() => _MealListPageState();
}

class _MealListPageState extends State<MealListPage> {
  MealListArgs? _args;
  late Future<List<MealSummary>> _futureMeals;
  String _filter = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // arguments baru bisa dibaca setelah context siap.
    if (_args == null) {
      _args = ModalRoute.of(context)!.settings.arguments as MealListArgs;
      _futureMeals = _load();
    }
  }

  /// Memilih endpoint sesuai jenis daftar.
  Future<List<MealSummary>> _load() {
    final args = _args!;
    return switch (args.type) {
      MealListType.category => ApiService.getMealsByCategory(args.value),
      MealListType.area => ApiService.getMealsByArea(args.value),
      MealListType.search => ApiService.searchMeals(args.value),
    };
  }

  void _reload() {
    setState(() => _futureMeals = _load());
  }

  @override
  Widget build(BuildContext context) {
    final args = _args!;

    return Scaffold(
      appBar: AppBar(title: Text(args.title)),
      body: FutureBuilder<List<MealSummary>>(
        future: _futureMeals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingView(message: 'Memuat daftar resep...');
          }
          if (snapshot.hasError) {
            return ErrorView(
              message: snapshot.error.toString(),
              onRetry: _reload,
            );
          }

          final allMeals = snapshot.data ?? [];
          if (allMeals.isEmpty) {
            return EmptyView(
              message: args.type == MealListType.search
                  ? 'Resep dengan kata "${args.value}" tidak ditemukan.\n'
                      'Coba kata lain dalam bahasa Inggris.'
                  : 'Belum ada resep di sini.',
            );
          }

          // Pengolahan data di sisi aplikasi: menyaring daftar berdasarkan
          // teks yang diketik pengguna.
          final meals = allMeals
              .where((m) => m.name.toLowerCase().contains(_filter.toLowerCase()))
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ListHeader(
                total: allMeals.length,
                shown: meals.length,
                onFilter: (value) => setState(() => _filter = value),
              ),
              Expanded(
                child: meals.isEmpty
                    ? const EmptyView(message: 'Tidak ada resep yang cocok.')
                    : _MealGrid(meals: meals),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ListHeader extends StatelessWidget {
  final int total;
  final int shown;
  final ValueChanged<String> onFilter;

  const _ListHeader({
    required this.total,
    required this.shown,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: onFilter,
            decoration: InputDecoration(
              hintText: 'Saring di daftar ini',
              prefixIcon: const Icon(Icons.filter_list),
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            shown == total ? '$total resep' : '$shown dari $total resep',
            style: const TextStyle(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

/// Grid resep. Jumlah kolom menyesuaikan lebar layar.
class _MealGrid extends StatelessWidget {
  final List<MealSummary> meals;

  const _MealGrid({required this.meals});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / 200).floor().clamp(2, 5).toInt();
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.78,
          ),
          itemCount: meals.length,
          itemBuilder: (context, index) => MealCard(
            meal: meals[index],
            onTap: () => Navigator.pushNamed(
              context,
              MealDetailPage.routeName,
              arguments: meals[index],
            ),
          ),
        );
      },
    );
  }
}
