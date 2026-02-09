import 'package:isar/isar.dart';

part 'mushaf_page_progress.g.dart';

/// تتبع إكمال صفحة مصحف — لشريط التقدم وربط LuminousEffect + ProgressSystem.
@collection
class MushafPageProgress {
  Id id = Isar.autoIncrement;

  /// رقم الصفحة 1..604 (مصحف المدينة)
  @Index(unique: true)
  late int pageNumber;

  @Index()
  late DateTime completedAt;

  MushafPageProgress();

  MushafPageProgress.forPage(this.pageNumber) : completedAt = DateTime.now();
}
