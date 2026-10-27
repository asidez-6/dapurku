import 'package:dapurku/models/meal.dart';
import 'package:dapurku/models/meal_category.dart';
import 'package:dapurku/models/meal_summary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('MealCategory.fromJson membaca data categories.php', () {
    final category = MealCategory.fromJson({
      'idCategory': '1',
      'strCategory': 'Beef',
      'strCategoryThumb': 'https://www.themealdb.com/images/category/beef.png',
      'strCategoryDescription': 'Beef is the culinary name for meat from cattle.',
    });

    expect(category.id, '1');
    expect(category.name, 'Beef');
  });

  test('MealSummary.fromJson membaca data filter.php', () {
    final meal = MealSummary.fromJson({
      'strMeal': 'Baked salmon with fennel & tomatoes',
      'strMealThumb': 'https://www.themealdb.com/images/media/meals/1548772327.jpg',
      'idMeal': '52959',
    });

    expect(meal.id, '52959');
    expect(meal.category, isNull);
  });

  test('Meal.fromJson merapikan bahan, tag, dan langkah', () {
    final json = <String, dynamic>{
      'idMeal': '52772',
      'strMeal': 'Teriyaki Chicken Casserole',
      'strCategory': 'Chicken',
      'strArea': 'Japanese',
      'strInstructions': 'STEP 1\r\nPreheat oven to 350F.\r\n\r\nSTEP 2\r\nCook the rice.',
      'strMealThumb': 'https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg',
      'strTags': 'Meat,Casserole',
      'strYoutube': 'https://www.youtube.com/watch?v=4aZr5hZXP_s',
      'strSource': '',
    };
    for (var i = 1; i <= 20; i++) {
      json['strIngredient$i'] = '';
      json['strMeasure$i'] = '';
    }
    json['strIngredient1'] = 'soy sauce';
    json['strMeasure1'] = '3/4 cup';
    json['strIngredient2'] = 'water';
    json['strMeasure2'] = '1/2 cup';
    json['strIngredient20'] = null;

    final meal = Meal.fromJson(json);

    expect(meal.ingredients.length, 2);
    expect(meal.ingredients.first.measure, '3/4 cup');
    expect(meal.tags, ['Meat', 'Casserole']);
    expect(meal.sourceUrl, isNull);
    expect(meal.steps, ['Preheat oven to 350F.', 'Cook the rice.']);
  });
}
