import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';

import '../models/mushaf_surah.dart';

/// المصدر الوحيد للمصحف: https://quran.com/
/// — API لفهرس السور، صور صفحات مصحف المدينة (604 صفحة) من مشروع Quran.com.
const String kQuranApiBase = 'https://api.quran.com/api/v4';
const int kMushafTotalPages = 604;

/// جلب السور من Quran.com API وبذرها في Isar للعمل بدون إنترنت.
Future<bool> fetchAndSeedMushafSurahs(Isar isar) async {
  try {
    final uri = Uri.parse('$kQuranApiBase/chapters');
    if (kDebugMode) debugPrint('[Mushaf] جلب السور من: $uri');
    final res = await http.get(uri).timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        if (kDebugMode) debugPrint('[Mushaf] timeout جلب السور');
        return http.Response('', 408);
      },
    );
    if (kDebugMode) debugPrint('[Mushaf] chapters status=${res.statusCode}');
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
    if (kDebugMode) debugPrint('[Mushaf] تم بذر ${surahs.length} سورة في Isar');
    return true;
  } catch (e, st) {
    if (kDebugMode) debugPrint('[Mushaf] خطأ جلب السور: $e\n$st');
    return false;
  }
}

/// صور المصحف: مصحف المدينة (604 صفحة).
/// — نستخدم GitHub (مستودع يعتمد على quran.com-images) لأن cdn.qurancdn.com قد لا يُحلّ على بعض الشبكات (DNS).
const String kMushafMedinaImagesBase =
    'https://raw.githubusercontent.com/tarekeldeeb/madina_images/w1024';

/// رابط صورة صفحة مصحف. الملفات: w1024_page001.png .. w1024_page604.png
String mushafPageImageUrl(int pageNumber) {
  if (pageNumber < 1 || pageNumber > kMushafTotalPages) return '';
  final padded = pageNumber.toString().padLeft(3, '0');
  final url = '$kMushafMedinaImagesBase/w1024_page$padded.png';
  return url;
}
