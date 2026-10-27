import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../models/meal_category.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/category_card.dart';
import '../widgets/net_image.dart';
import '../widgets/section_title.dart';
import '../widgets/state_views.dart';
import 'meal_detail_page.dart';
import 'meal_list_page.dart';

/// Tab Beranda: kolom pencarian, rekomendasi resep acak, dan kategori.
///
/// Ada dua permintaan API yang berjalan bersamaan dan masing-masing punya
/// FutureBuilder sendiri, sehingga kondisi loading/error tiap bagian
/// tidak saling menunggu.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Future disimpan di State supaya permintaan tidak dikirim ulang
  // setiap kali build() dipanggil.
  late Future<Meal> _futureRandom;
  late Future<List<MealCategory>> _futureCategories;

  @override
  void initState() {
    super.initState();
    _futureRandom = ApiService.getRandomMeal();
    _futureCategories = ApiService.getCategories();
  }

  void _reloadRandom() {
    setState(() => _futureRandom = ApiService.getRandomMeal());
  }

  void _reloadCategories() {
    setState(() => _futureCategories = ApiService.getCategories());
  }

  /// Tarik-untuk-refresh: muat ulang kedua bagian.
  Future<void> _refreshAll() async {
    _reloadRandom();
    _reloadCategories();
    try {
      await Future.wait([_futureRandom, _futureCategories]);
    } catch (_) {
      // Error sudah ditampilkan oleh masing-masing FutureBuilder.
    }
  }

  void _search(String keyword) {
    Navigator.pushNamed(
      context,
      MealListPage.routeName,
      arguments: MealListArgs.search(keyword),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshAll,
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          _Header(onSearch: _search),

          // ---------- Rekomendasi (random.php) ----------
          SectionTitle(
            title: 'Rekomendasi Hari Ini',
            actionLabel: 'Acak',
            actionIcon: Icons.shuffle,
            onAction: _reloadRandom,
          ),
          FutureBuilder<Meal>(
            future: _futureRandom,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 220,
                  child: LoadingView(message: 'Mencari resep untukmu...'),
                );
              }
              if (snapshot.hasError) {
                return ErrorView(
                  message: snapshot.error.toString(),
                  onRetry: _reloadRandom,
                );
              }
              return _RecommendationCard(meal: snapshot.data!);
            },
          ),

          // ---------- Kategori (categories.php) ----------
          const SectionTitle(title: 'Kategori Masakan'),
          FutureBuilder<List<MealCategory>>(
            future: _futureCategories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 200,
                  child: LoadingView(message: 'Memuat kategori...'),
                );
              }
              if (snapshot.hasError) {
                return ErrorView(
                  message: snapshot.error.toString(),
                  onRetry: _reloadCategories,
                );
              }
              final categories = snapshot.data ?? [];
              if (categories.isEmpty) {
                return const EmptyView(message: 'Kategori belum tersedia.');
              }
              return _CategoryGrid(categories: categories);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Bagian atas: sapaan dan kolom pencarian.
class _Header extends StatelessWidget {
  final ValueChanged<String> onSearch;

  const _Header({required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 20, // jarak dari status bar
        16,
        24,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.soup_kitchen, color: Colors.white, size: 30),
              SizedBox(width: 8),
              Text(
                'Dapurku',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Mau masak apa hari ini?',
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
          const SizedBox(height: 16),
          TextField(
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) onSearch(value.trim());
            },
            decoration: InputDecoration(
              hintText: 'Cari resep, contoh: chicken, soup, cake',
              hintStyle: const TextStyle(color: AppColors.textMuted),
              prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Kartu besar untuk resep acak dari random.php.
class _RecommendationCard extends StatelessWidget {
  final Meal meal;

  const _RecommendationCard({required this.meal});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // Tinggi kartu mengikuti lebar layar, dibatasi agar pas di tablet.
    final height = (width * 0.55).clamp(180.0, 320.0).toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          MealDetailPage.routeName,
          arguments: meal.toSummary(),
        ),
        child: SizedBox(
          height: height,
          child: Stack(
            children: [
              Positioned.fill(child: NetImage(url: meal.thumbnail, radius: 18)),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(
                    color: AppColors.overlay,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(18),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${meal.category} • ${meal.area} • ${meal.ingredients.length} bahan',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Grid kategori. Jumlah kolom menyesuaikan lebar layar (responsif).
class _CategoryGrid extends StatelessWidget {
  final List<MealCategory> categories;

  const _CategoryGrid({required this.categories});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / 130).floor().clamp(3, 6).toInt();
        return GridView.builder(
          // GridView di dalam ListView: tinggi mengikuti isi, scroll ikut induk.
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.95,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryCard(
              category: category,
              onTap: () => Navigator.pushNamed(
                context,
                MealListPage.routeName,
                arguments: MealListArgs.category(category),
              ),
            );
          },
        );
      },
    );
  }
}
