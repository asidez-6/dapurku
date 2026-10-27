/// Model satu kategori masakan dari endpoint `categories.php`.
///
/// Contoh JSON:
/// {
///   "idCategory": "1",
///   "strCategory": "Beef",
///   "strCategoryThumb": "https://www.themealdb.com/images/category/beef.png",
///   "strCategoryDescription": "Beef is the culinary name for meat from cattle..."
/// }
class MealCategory {
  final String id;
  final String name;
  final String thumbnail;
  final String description;

  const MealCategory({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.description,
  });

  factory MealCategory.fromJson(Map<String, dynamic> json) {
    return MealCategory(
      id: json['idCategory']?.toString() ?? '',
      name: json['strCategory']?.toString() ?? '-',
      thumbnail: json['strCategoryThumb']?.toString() ?? '',
      description: json['strCategoryDescription']?.toString() ?? '',
    );
  }
}
