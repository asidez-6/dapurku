import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/meal.dart';
import '../models/meal_summary.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/area_info.dart';
import '../widgets/net_image.dart';
import '../widgets/state_views.dart';

/// Halaman detail resep.
///
/// Nama dan foto resep diterima lewat arguments sehingga langsung tampil.
/// Data lengkap (bahan, takaran, langkah) diambil dari lookup.php?i={id}.
class MealDetailPage extends StatefulWidget {
  const MealDetailPage({super.key});

  static const routeName = '/detail';

  @override
  State<MealDetailPage> createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  MealSummary? _summary;
  late Future<Meal> _futureDetail;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Permintaan detail hanya dikirim sekali, saat halaman pertama dibuka.
    if (_summary == null) {
      _summary = ModalRoute.of(context)!.settings.arguments as MealSummary;
      _futureDetail = ApiService.getMealDetail(_summary!.id);
    }
  }

  void _reload() {
    setState(() => _futureDetail = ApiService.getMealDetail(_summary!.id));
  }

  @override
  Widget build(BuildContext context) {
    final summary = _summary!;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar dengan foto besar yang mengecil saat digulir.
          SliverAppBar(
            pinned: true,
            expandedHeight: (screenWidth * 0.75).clamp(200.0, 420.0).toDouble(),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            title: Text(summary.name, maxLines: 1, overflow: TextOverflow.ellipsis),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'meal-${summary.id}',
                child: NetImage(url: summary.thumbnail, radius: 0),
              ),
            ),
          ),
          SliverToBoxAdapter(
            // Di layar lebar, isi dibatasi 720 px dan diletakkan di tengah.
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: FutureBuilder<Meal>(
                  future: _futureDetail,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 48),
                        child: LoadingView(message: 'Memuat resep...'),
                      );
                    }
                    if (snapshot.hasError) {
                      return ErrorView(
                        message: snapshot.error.toString(),
                        onRetry: _reload,
                      );
                    }
                    return _DetailContent(meal: snapshot.data!);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final Meal meal;

  const _DetailContent({required this.meal});

  @override
  Widget build(BuildContext context) {
    final area = AreaInfo.of(meal.area);
    final steps = meal.steps;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            meal.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Chip(icon: Icons.restaurant_menu, text: meal.category),
              _Chip(icon: Icons.public, text: '${area.flag} ${area.name}'),
              for (final tag in meal.tags) _Chip(icon: Icons.tag, text: tag),
            ],
          ),

          // ---------- Bahan ----------
          const SizedBox(height: 20),
          _SectionHeader(
            icon: Icons.shopping_basket_outlined,
            title: 'Bahan (${meal.ingredients.length})',
          ),
          const SizedBox(height: 8),
          Card(
            color: AppColors.card,
            elevation: 1.5,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Column(
              children: [
                for (var i = 0; i < meal.ingredients.length; i++) ...[
                  if (i > 0) const Divider(height: 1, indent: 64),
                  _IngredientRow(ingredient: meal.ingredients[i]),
                ],
              ],
            ),
          ),

          // ---------- Langkah ----------
          const SizedBox(height: 20),
          _SectionHeader(
            icon: Icons.format_list_numbered,
            title: 'Langkah Memasak (${steps.length})',
          ),
          const SizedBox(height: 8),
          if (steps.isEmpty)
            const Text('Langkah memasak tidak tersedia.',
                style: TextStyle(color: AppColors.textMuted))
          else
            for (var i = 0; i < steps.length; i++)
              _StepRow(number: i + 1, text: steps[i]),

          // ---------- Video ----------
          if (meal.youtubeUrl != null) ...[
            const SizedBox(height: 12),
            _VideoCard(url: meal.youtubeUrl!),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textMain,
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Chip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.chip,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primaryDark),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(color: AppColors.primaryDark, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  final Ingredient ingredient;

  const _IngredientRow({required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          NetImage(
            url: ingredient.imageUrl,
            width: 40,
            height: 40,
            radius: 8,
            fit: BoxFit.contain,
            fallbackIcon: Icons.eco,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              ingredient.name,
              style: const TextStyle(color: AppColors.textMain),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              ingredient.measure,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final int number;
  final String text;

  const _StepRow({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: AppColors.primary,
            child: Text(
              '$number',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.justify,
              style: const TextStyle(height: 1.5, color: AppColors.textMain),
            ),
          ),
        ],
      ),
    );
  }
}

/// Link video YouTube. Tidak memakai package tambahan: link bisa disalin
/// ke clipboard lalu dibuka di browser/YouTube.
class _VideoCard extends StatelessWidget {
  final String url;

  const _VideoCard({required this.url});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.card,
      elevation: 1.5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: const Icon(Icons.ondemand_video, color: Colors.red),
        title: const Text('Video tutorial'),
        subtitle: Text(url, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: IconButton(
          tooltip: 'Salin link',
          icon: const Icon(Icons.copy),
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: url));
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Link video disalin')),
            );
          },
        ),
      ),
    );
  }
}
