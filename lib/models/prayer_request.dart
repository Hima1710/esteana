import 'package:isar/isar.dart';

part 'prayer_request.g.dart';

/// طلب دعاء — للمجلس، بيانات وهمية أو حقيقية لاحقاً.
@collection
class PrayerRequest {
  Id id = Isar.autoIncrement;

  late String text;
  @Index()
  late DateTime createdAt;
  /// المستخدم الحالي دعا له
  late bool prayedByMe;

  PrayerRequest();
}
