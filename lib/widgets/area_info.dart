/// Nama negara dalam bahasa Indonesia dan bendera (emoji) untuk setiap
/// nilai `strArea` dari TheMealDB. Kalau belum ada di daftar, nama asli
/// dari API tetap ditampilkan dengan ikon bola dunia.
class AreaInfo {
  final String name;
  final String flag;

  const AreaInfo(this.name, this.flag);

  static const Map<String, AreaInfo> _known = {
    'Algerian': AreaInfo('Aljazair', '🇩🇿'),
    'American': AreaInfo('Amerika Serikat', '🇺🇸'),
    'Argentinian': AreaInfo('Argentina', '🇦🇷'),
    'Australian': AreaInfo('Australia', '🇦🇺'),
    'British': AreaInfo('Inggris', '🇬🇧'),
    'Canadian': AreaInfo('Kanada', '🇨🇦'),
    'Chinese': AreaInfo('Tiongkok', '🇨🇳'),
    'Croatian': AreaInfo('Kroasia', '🇭🇷'),
    'Dutch': AreaInfo('Belanda', '🇳🇱'),
    'Egyptian': AreaInfo('Mesir', '🇪🇬'),
    'Filipino': AreaInfo('Filipina', '🇵🇭'),
    'French': AreaInfo('Prancis', '🇫🇷'),
    'Greek': AreaInfo('Yunani', '🇬🇷'),
    'Indian': AreaInfo('India', '🇮🇳'),
    'Indonesian': AreaInfo('Indonesia', '🇮🇩'),
    'Irish': AreaInfo('Irlandia', '🇮🇪'),
    'Italian': AreaInfo('Italia', '🇮🇹'),
    'Jamaican': AreaInfo('Jamaika', '🇯🇲'),
    'Japanese': AreaInfo('Jepang', '🇯🇵'),
    'Kenyan': AreaInfo('Kenya', '🇰🇪'),
    'Malaysian': AreaInfo('Malaysia', '🇲🇾'),
    'Mexican': AreaInfo('Meksiko', '🇲🇽'),
    'Moroccan': AreaInfo('Maroko', '🇲🇦'),
    'Norwegian': AreaInfo('Norwegia', '🇳🇴'),
    'Polish': AreaInfo('Polandia', '🇵🇱'),
    'Portuguese': AreaInfo('Portugal', '🇵🇹'),
    'Russian': AreaInfo('Rusia', '🇷🇺'),
    'Saudi Arabian': AreaInfo('Arab Saudi', '🇸🇦'),
    'Slovakian': AreaInfo('Slowakia', '🇸🇰'),
    'Spanish': AreaInfo('Spanyol', '🇪🇸'),
    'Syrian': AreaInfo('Suriah', '🇸🇾'),
    'Thai': AreaInfo('Thailand', '🇹🇭'),
    'Tunisian': AreaInfo('Tunisia', '🇹🇳'),
    'Turkish': AreaInfo('Turki', '🇹🇷'),
    'Ukrainian': AreaInfo('Ukraina', '🇺🇦'),
    'Uruguayan': AreaInfo('Uruguay', '🇺🇾'),
    'Venezulan': AreaInfo('Venezuela', '🇻🇪'),
    'Vietnamese': AreaInfo('Vietnam', '🇻🇳'),
  };

  static AreaInfo of(String area) => _known[area] ?? AreaInfo(area, '🌍');
}
