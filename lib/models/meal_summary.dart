/// Data ringkas satu resep. Dipakai untuk daftar resep.
///
/// Endpoint `filter.php` hanya mengirim tiga atribut:
/// { "strMeal": "Baked salmon with fennel & tomatoes",
///   "strMealThumb": "https://www.themealdb.com/images/media/meals/1548772327.jpg",
///   "idMeal": "52959" }
///
/// Endpoint `search.php` mengirim data lengkap, sehingga [category] dan
/// [area] ikut terisi. Karena itu keduanya boleh null.
class MealSummary {
  final String id;
  final String name;
  final String thumbnail;
  final String? category;
  final String? area;

  const MealSummary({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.category,
    this.area,
  });

  factory MealSummary.fromJson(Map<String, dynamic> json) {
    return MealSummary(
      id: json['idMeal']?.toString() ?? '',
      name: json['strMeal']?.toString() ?? '-',
      thumbnail: json['strMealThumb']?.toString() ?? '',
      category: json['strCategory']?.toString(),
      area: json['strArea']?.toString(),
    );
  }
}
