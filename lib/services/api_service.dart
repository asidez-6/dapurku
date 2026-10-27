import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/meal.dart';
import '../models/meal_category.dart';
import '../models/meal_summary.dart';

/// Kesalahan saat mengambil data dari API.
/// [message] berisi pesan yang ramah untuk ditampilkan ke pengguna.
class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

/// Semua permintaan HTTP ke TheMealDB dikumpulkan di kelas ini.
///
/// Endpoint yang dipakai (base: https://www.themealdb.com/api/json/v1/1):
/// - categories.php          -> daftar kategori
/// - random.php              -> satu resep acak (rekomendasi)
/// - filter.php?c={kategori} -> resep per kategori
/// - filter.php?a={negara}   -> resep per asal negara
/// - list.php?a=list         -> daftar asal negara
/// - search.php?s={kata}     -> cari resep berdasarkan nama
/// - lookup.php?i={id}       -> detail satu resep
class ApiService {
  static const String host = 'www.themealdb.com';
  static const String basePath = '/api/json/v1/1';
  static const String baseUrl = 'https://$host$basePath';
  static const Duration _timeout = Duration(seconds: 15);

  static Future<List<MealCategory>> getCategories() async {
    final json = await _get('categories.php');
    return _list(json, 'categories')
        .map((item) => MealCategory.fromJson(item))
        .toList();
  }

  static Future<Meal> getRandomMeal() async {
    final json = await _get('random.php');
    final meals = _list(json, 'meals');
    if (meals.isEmpty) {
      throw const ApiException('Rekomendasi resep tidak tersedia.');
    }
    return Meal.fromJson(meals.first);
  }

  static Future<List<MealSummary>> getMealsByCategory(String category) async {
    final json = await _get('filter.php', {'c': category});
    return _list(json, 'meals').map((m) => MealSummary.fromJson(m)).toList();
  }

  static Future<List<MealSummary>> getMealsByArea(String area) async {
    final json = await _get('filter.php', {'a': area});
    return _list(json, 'meals').map((m) => MealSummary.fromJson(m)).toList();
  }

  static Future<List<MealSummary>> searchMeals(String keyword) async {
    final json = await _get('search.php', {'s': keyword});
    return _list(json, 'meals').map((m) => MealSummary.fromJson(m)).toList();
  }

  static Future<List<String>> getAreas() async {
    final json = await _get('list.php', {'a': 'list'});
    final areas = _list(json, 'meals')
        .map((m) => m['strArea']?.toString() ?? '')
        .where((a) => a.isNotEmpty && a != 'Unknown')
        .toList();
    areas.sort();
    return areas;
  }

  static Future<Meal> getMealDetail(String id) async {
    final json = await _get('lookup.php', {'i': id});
    final meals = _list(json, 'meals');
    if (meals.isEmpty) {
      throw const ApiException('Resep tidak ditemukan.');
    }
    return Meal.fromJson(meals.first);
  }

  /// Mengambil list dari respons. TheMealDB mengirim `"meals": null`
  /// kalau hasilnya kosong, jadi null diubah menjadi list kosong.
  static List<Map<String, dynamic>> _list(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) return [];
    if (value is! List) {
      throw const ApiException('Format data dari server tidak sesuai.');
    }
    return value.whereType<Map<String, dynamic>>().toList();
  }

  /// Mengirim GET, memeriksa status respons, lalu mengubah body JSON
  /// menjadi Map Dart.
  static Future<Map<String, dynamic>> _get(
    String endpoint, [
    Map<String, String>? query,
  ]) async {
    // Uri.https otomatis meng-encode parameter, misalnya spasi pada
    // nama kategori atau kata pencarian.
    final url = Uri.https(host, '$basePath/$endpoint', query);
    try {
      final response = await http.get(url).timeout(_timeout);

      if (response.statusCode != 200) {
        throw ApiException(
            'Server membalas dengan kode ${response.statusCode}. Coba lagi nanti.');
      }
      final body = jsonDecode(response.body);
      if (body is! Map<String, dynamic>) {
        throw const ApiException('Format data dari server tidak sesuai.');
      }
      return body;
    } on SocketException {
      throw const ApiException(
          'Tidak ada koneksi internet. Periksa jaringanmu lalu coba lagi.');
    } on TimeoutException {
      throw const ApiException(
          'Server terlalu lama merespons. Coba lagi beberapa saat lagi.');
    } on FormatException {
      throw const ApiException('Data dari server tidak bisa dibaca.');
    } on http.ClientException {
      throw const ApiException(
          'Gagal terhubung ke server. Periksa koneksi internetmu lalu coba lagi.');
    }
  }
}
