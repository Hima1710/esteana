// ignore_for_file: unused_element

import '../services/mushaf_api_service.dart';

/// طبقة تجريد لعرض المصحف — المصدر الوحيد: https://quran.com/ (صور فقط).
abstract class QuranProvider {
  /// إجمالي عدد الصفحات (مصحف المدينة = 604).
  int get totalPages;

  /// لا يُستخدم — العرض صور فقط. مُبقى للواجهة.
  Future<List<Map<String, dynamic>>> getVerses(int pageNumber);

  /// رابط صورة صفحة مصحف من Quran.com.
  String pageImageUrl(int pageNumber);
}

/// التنفيذ: Quran.com — صور الصفحات فقط.
class QuranApiProvider implements QuranProvider {
  @override
  int get totalPages => kMushafTotalPages;

  @override
  Future<List<Map<String, dynamic>>> getVerses(int pageNumber) =>
      Future.value(<Map<String, dynamic>>[]);

  @override
  String pageImageUrl(int pageNumber) => mushafPageImageUrl(pageNumber);
}
