import 'package:isar/isar.dart';

part 'dhikr_day_progress.g.dart';

/// تقدم الأذكار ليوم واحد — مرتبط بـ dateKey لتصفير تلقائي عند يوم جديد.
@collection
class DhikrDayProgress {
  Id id = Isar.autoIncrement;

  /// تاريخ اليوم: yyyyMMdd
  @Index()
  late int dateKey;

  /// معرّف الفئة: morning, evening, afterPrayer, sleep, tawba
  late String categoryId;

  /// العداد المتبقي لكل عنصر (مخزن كـ "1,2,0,10" للتوبة: قيمة واحدة)
  late String countsJson;

  late DateTime updatedAt;

  DhikrDayProgress();

  static List<int> parseCounts(String json) {
    if (json.isEmpty) return [];
    return json.split(',').map((e) => int.tryParse(e.trim()) ?? 0).toList();
  }

  static String serializeCounts(List<int> counts) {
    return counts.join(',');
  }
}
