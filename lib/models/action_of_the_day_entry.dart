import 'package:isar/isar.dart';

part 'action_of_the_day_entry.g.dart';

/// تحدي اليوم — مهمة واحدة عشوائية ليوم واحد، حالة الإنجاز في Isar.
@collection
class ActionOfTheDayEntry {
  Id id = Isar.autoIncrement;

  /// تاريخ اليوم كعدد yyyyMMdd للاستعلام السريع
  @Index(unique: true)
  late int dateKey;

  late String taskKey;
  late String titleAr;
  late String titleEn;
  late bool completed;
  DateTime? completedAt;

  ActionOfTheDayEntry();
}
