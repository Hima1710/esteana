import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';

import '../models/mushaf_surah.dart';

/// مصدر بيانات المصحف: API Quran.com — سور وصفحات (مصحف المدينة 604 صفحة).
const String kQuranApiBase = 'https://api.quran.com/api/v4';
const int kMushafTotalPages = 604;

/// جلب السور من API وبذرها في Isar للعمل بدون إنترنت.
Future<bool> fetchAndSeedMushafSurahs(Isar isar) async {
  try {
    final res = await http.get(Uri.parse('$kQuranApiBase/chapters')).timeout(
      const Duration(seconds: 15),
      onTimeout: () => http.Response('', 408),
    );
    if (res.statusCode != 200) return false;
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final chapters = body['chapters'] as List<dynamic>?;
    if (chapters == null || chapters.isEmpty) return false;

    final surahs = chapters
        .map((e) => MushafSurah.fromQuranApi(e as Map<String, dynamic>))
        .toList();

    await isar.writeTxn(() async {
      await isar.mushafSurahs.clear();
      await isar.mushafSurahs.putAll(surahs);
    });
    return true;
  } catch (_) {
    return false;
  }
}

/// جلب آيات صفحة معينة (عثماني) للعرض النصي.
Future<List<Map<String, dynamic>>> fetchVersesByPage(int pageNumber) async {
  if (pageNumber < 1 || pageNumber > kMushafTotalPages) return [];
  try {
    final res = await http
        .get(Uri.parse('$kQuranApiBase/quran/verses/uthmani?page_number=$pageNumber'))
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () => http.Response('', 408),
    );
    if (res.statusCode != 200) return [];
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final verses = body['verses'] as List<dynamic>?;
    if (verses == null) return [];
    return verses.map((e) => e as Map<String, dynamic>).toList();
  } catch (_) {
    return [];
  }
}

/// رابط صورة صفحة مصحف (مصحف المدينة) — للعرض الاختياري.
/// إن لم يعمل الرابط يُعرض النص تلقائياً في القارئ.
String mushafPageImageUrl(int pageNumber) {
  if (pageNumber < 1 || pageNumber > kMushafTotalPages) return '';
  return 'https://cdn.qurancdn.com/images/medina/$pageNumber.png';
}
