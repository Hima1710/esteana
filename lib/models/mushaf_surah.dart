import 'package:isar/isar.dart';

part 'mushaf_surah.g.dart';

/// بيانات سورة واحدة — مصدرها API Quran.com، مُخزّنة في Isar للعمل بدون إنترنت.
@collection
class MushafSurah {
  Id id = Isar.autoIncrement;

  /// رقم السورة 1..114
  @Index()
  late int surahNumber;

  late String nameAr;
  late String nameEn;
  /// makkah | madinah
  late String revelationPlace;
  late int versesCount;
  /// أول صفحة في مصحف المدينة (1..604)
  late int startPage;
  /// آخر صفحة في مصحف المدينة
  late int endPage;

  MushafSurah();

  factory MushafSurah.fromQuranApi(Map<String, dynamic> json) {
    final pages = json['pages'] as List<dynamic>?;
    final start = (pages != null && pages.isNotEmpty) ? (pages[0] as num).toInt() : 1;
    final end = (pages != null && pages.length > 1) ? (pages[1] as num).toInt() : start;
    final translated = json['translated_name'] as Map<String, dynamic>?;
    final nameEn = translated?['name'] as String? ?? (json['name_simple'] as String? ?? '');
    return MushafSurah()
      ..surahNumber = (json['id'] as num).toInt()
      ..nameAr = json['name_arabic'] as String? ?? ''
      ..nameEn = nameEn
      ..revelationPlace = json['revelation_place'] as String? ?? 'makkah'
      ..versesCount = (json['verses_count'] as num?)?.toInt() ?? 0
      ..startPage = start
      ..endPage = end;
  }
}
