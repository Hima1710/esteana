import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'mushaf_api_service.dart';

/// تخزين وتحميل صفحات المصحف محلياً للعمل دون إنترنت.
class MushafStorageService {
  MushafStorageService._();

  static String? _dir;

  /// يُستدعى مرة واحدة قبل استخدام [getLocalPathForPage] أو [downloadAllMushafPages].
  static Future<void> ensureInit() async {
    if (_dir != null) return;
    final appDir = await getApplicationDocumentsDirectory();
    _dir = '${appDir.path}/mushaf_pages';
  }

  /// مسار المجلد الذي تُحفظ فيه الصفحات.
  static String? get mushafPagesPath => _dir;

  /// إن وُجدت نسخة محلية للصفحة يُرجع مسار الملف، وإلا null.
  static String? getLocalPathForPage(int pageNumber) {
    if (_dir == null || pageNumber < 1 || pageNumber > kMushafTotalPages) return null;
    final name = 'w1024_page${pageNumber.toString().padLeft(3, '0')}.png';
    final path = '$_dir/$name';
    return File(path).existsSync() ? path : null;
  }

  /// عدد الصفحات المحمّلة محلياً.
  static int get downloadedCount {
    if (_dir == null) return 0;
    final dir = Directory(_dir!);
    if (!dir.existsSync()) return 0;
    return dir.listSync().where((e) => e.path.endsWith('.png')).length;
  }

  /// تحميل كل الصفحات مع إبلاغ التقدم وإمكانية الإلغاء.
  static Future<void> downloadAllMushafPages({
    required void Function(int current, int total) onProgress,
    required bool Function() isCancelled,
  }) async {
    await ensureInit();
    final dir = Directory(_dir!);
    if (!dir.existsSync()) dir.createSync(recursive: true);

    const total = kMushafTotalPages;
    for (var page = 1; page <= total; page++) {
      if (isCancelled()) return;
      final path = getLocalPathForPage(page);
      if (path != null) {
        onProgress(page, total);
        continue;
      }
      final url = mushafPageImageUrl(page);
      if (url.isEmpty) {
        onProgress(page, total);
        continue;
      }
      try {
        final res = await http.get(Uri.parse(url)).timeout(
          const Duration(seconds: 30),
          onTimeout: () => http.Response('', 408),
        );
        if (res.statusCode == 200 && res.bodyBytes.isNotEmpty) {
          final name = 'w1024_page${page.toString().padLeft(3, '0')}.png';
          final file = File('$_dir/$name');
          await file.writeAsBytes(res.bodyBytes);
        }
      } catch (e) {
        if (kDebugMode) debugPrint('[Mushaf] خطأ تحميل صفحة $page: $e');
      }
      onProgress(page, total);
    }
  }
}
