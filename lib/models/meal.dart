import 'meal_summary.dart';

/// Satu bahan beserta takarannya, contoh: "Salmon" - "2 fillets".
class Ingredient {
  final String name;
  final String measure;

  const Ingredient({required this.name, required this.measure});

  /// Gambar kecil bahan yang disediakan TheMealDB.
  String get imageUrl =>
      'https://www.themealdb.com/images/ingredients/${Uri.encodeComponent(name)}-Small.png';
}

/// Model detail lengkap satu resep dari endpoint `lookup.php?i={id}`
/// dan `random.php`.
///
/// API menyimpan bahan dalam 20 pasang atribut terpisah
/// (strIngredient1..strIngredient20 dan strMeasure1..strMeasure20).
/// Di [Meal.fromJson] pasangan itu dirapikan menjadi satu List<Ingredient>,
/// dan pasangan yang kosong dibuang.
class Meal {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnail;
  final List<String> tags;
  final String? youtubeUrl;
  final String? sourceUrl;
  final List<Ingredient> ingredients;

  const Meal({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    required this.tags,
    required this.ingredients,
    this.youtubeUrl,
    this.sourceUrl,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    final ingredients = <Ingredient>[];
    for (var i = 1; i <= 20; i++) {
      final name = json['strIngredient$i']?.toString().trim() ?? '';
      final measure = json['strMeasure$i']?.toString().trim() ?? '';
      if (name.isNotEmpty) {
        ingredients.add(Ingredient(name: name, measure: measure));
      }
    }

    final tagsText = json['strTags']?.toString() ?? '';

    return Meal(
      id: json['idMeal']?.toString() ?? '',
      name: json['strMeal']?.toString() ?? '-',
      category: json['strCategory']?.toString() ?? '-',
      area: json['strArea']?.toString() ?? '-',
      instructions: json['strInstructions']?.toString() ?? '',
      thumbnail: json['strMealThumb']?.toString() ?? '',
      tags: tagsText
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList(),
      youtubeUrl: _emptyToNull(json['strYoutube']),
      sourceUrl: _emptyToNull(json['strSource']),
      ingredients: ingredients,
    );
  }

  static String? _emptyToNull(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }

  /// Langkah memasak: teks instruksi dipecah per baris, baris kosong dan
  /// penanda seperti "STEP 1" dibuang.
  List<String> get steps {
    return instructions
        .split(RegExp(r'\r?\n'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .where((line) => !RegExp(r'^(step\s*)?\d+\.?$', caseSensitive: false)
            .hasMatch(line))
        .toList();
  }

  /// Mengubah detail menjadi data ringkas, misalnya untuk dikirim ke
  /// halaman detail lewat arguments.
  MealSummary toSummary() => MealSummary(
        id: id,
        name: name,
        thumbnail: thumbnail,
        category: category,
        area: area,
      );
}
