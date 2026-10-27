# Dapurku 🍲

Aplikasi resep masakan dunia berbasis **Flutter** yang mengambil data secara langsung dari **[TheMealDB API](https://www.themealdb.com/api.php)**.
Dibuat untuk Ujian Tengah Semester (UTS) Praktikum Pemrograman Mobile, kelas M.

> Muhammad Ihsan Anshorudin · 240605110199
> Teknik Informatika, Fakultas Sains dan Teknologi, UIN Maulana Malik Ibrahim Malang

## Deskripsi

Bingung mau masak apa? Dapurku menampilkan ratusan resep dari berbagai negara.
Pengguna dapat mencari resep berdasarkan nama, mendapat rekomendasi resep acak,
menjelajah berdasarkan kategori atau asal negara, lalu melihat bahan, takaran,
dan langkah memasak secara lengkap.

## Fitur Utama

| Fitur | Endpoint API |
| --- | --- |
| Rekomendasi resep acak (bisa diacak ulang) | `random.php` |
| Daftar kategori masakan dalam grid | `categories.php` |
| Daftar resep per kategori | `filter.php?c={kategori}` |
| Daftar asal negara masakan + bendera | `list.php?a=list` |
| Daftar resep per negara | `filter.php?a={negara}` |
| Pencarian resep berdasarkan nama | `search.php?s={kata}` |
| Detail resep: bahan + takaran + gambar bahan, langkah memasak, tag, link video | `lookup.php?i={id}` |
| Saring daftar resep secara lokal | (diolah di aplikasi) |

Setiap pengambilan data memakai **FutureBuilder** dengan tiga kondisi:

- **Loading**: indikator berputar dan keterangan.
- **Success**: data ditampilkan.
- **Error**: pesan yang jelas (tidak ada internet, server lambat, data tidak terbaca) dan tombol **Coba Lagi**.

Data kosong (misalnya pencarian tanpa hasil) juga diberi tampilan khusus.

## Teknologi dan Package

- Flutter (Material 3) dan Dart
- [`http`](https://pub.dev/packages/http) untuk mengirim permintaan HTTP GET ke API
- `dart:convert` (`jsonDecode`) untuk mengubah JSON menjadi `Map`, lalu ke class model
- Navigasi: `NavigationBar` (3 tab) dan Named Route dengan `arguments`

## Struktur Folder

```
lib/
├─ main.dart                   # MaterialApp + daftar route
├─ models/
│  ├─ meal_category.dart       # model kategori
│  ├─ meal_summary.dart        # model ringkas resep (untuk daftar)
│  └─ meal.dart                # model detail resep + Ingredient
├─ services/
│  └─ api_service.dart         # semua request HTTP + penanganan error
├─ pages/
│  ├─ main_page.dart           # NavigationBar: Beranda, Negara, Tentang
│  ├─ home_page.dart           # cari, rekomendasi acak, grid kategori
│  ├─ area_page.dart           # daftar asal negara
│  ├─ meal_list_page.dart      # daftar resep (kategori/negara/pencarian)
│  ├─ meal_detail_page.dart    # detail resep
│  └─ about_page.dart          # tentang aplikasi
├─ widgets/                    # komponen yang dipakai ulang
│  ├─ state_views.dart         # LoadingView, ErrorView, EmptyView
│  ├─ meal_card.dart, category_card.dart, net_image.dart
│  ├─ section_title.dart
│  └─ area_info.dart           # nama negara (Indonesia) + bendera
└─ theme/app_theme.dart        # palet warna
test/
└─ meal_model_test.dart        # unit test konversi JSON -> model
```

## Cara Menjalankan

Prasyarat: Flutter SDK 3.24 atau lebih baru, dan emulator/HP Android yang terhubung ke internet.

```bash
git clone https://github.com/<username>/dapurku.git
cd dapurku
flutter pub get
flutter run
```

Menjalankan unit test:

```bash
flutter test
```

> Untuk build APK release, pastikan `android/app/src/main/AndroidManifest.xml` berisi
> `<uses-permission android:name="android.permission.INTERNET"/>`.

## Sumber Data

[TheMealDB](https://www.themealdb.com/) — API resep masakan gratis. Aplikasi ini memakai test key `1` yang disediakan untuk keperluan pengembangan dan edukasi.
