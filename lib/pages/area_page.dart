import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/area_info.dart';
import '../widgets/state_views.dart';
import 'meal_list_page.dart';

/// Tab Negara: daftar asal masakan dari endpoint list.php?a=list.
class AreaPage extends StatefulWidget {
  const AreaPage({super.key});

  @override
  State<AreaPage> createState() => _AreaPageState();
}

class _AreaPageState extends State<AreaPage> {
  late Future<List<String>> _futureAreas;

  @override
  void initState() {
    super.initState();
    _futureAreas = ApiService.getAreas();
  }

  void _reload() {
    setState(() => _futureAreas = ApiService.getAreas());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Masakan Dunia')),
      body: FutureBuilder<List<String>>(
        future: _futureAreas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingView(message: 'Memuat daftar negara...');
          }
          if (snapshot.hasError) {
            return ErrorView(
              message: snapshot.error.toString(),
              onRetry: _reload,
            );
          }
          final areas = snapshot.data ?? [];
          if (areas.isEmpty) {
            return const EmptyView(message: 'Daftar negara belum tersedia.');
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final columns =
                  (constraints.maxWidth / 170).floor().clamp(2, 6).toInt();
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 64,
                ),
                itemCount: areas.length,
                itemBuilder: (context, index) {
                  final area = areas[index];
                  final info = AreaInfo.of(area);
                  return Card(
                    color: AppColors.card,
                    elevation: 1.5,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(
                        context,
                        MealListPage.routeName,
                        arguments: MealListArgs.area(area),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Text(info.flag, style: const TextStyle(fontSize: 26)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                info.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textMain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
