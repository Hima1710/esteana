import 'package:isar/isar.dart';

part 'daily_task.g.dart';

/// مهمة يومية — للاستخدام في قسم أثري - يومي.
@collection
class DailyTask {
  Id id = Isar.autoIncrement;

  late String title;
  String? description;
  @Index()
  late bool completed;
  late int sortOrder;
  @Index()
  late DateTime createdAt;
  DateTime? updatedAt;
  String? externalId;

  DailyTask();

  factory DailyTask.fromJson(Map<String, dynamic> json) {
    return DailyTask()
      ..title = json['title'] as String
      ..description = json['description'] as String?
      ..completed = json['completed'] as bool? ?? false
      ..sortOrder = (json['sort_order'] as num?)?.toInt() ?? 0
      ..createdAt = json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now()
      ..updatedAt = json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null
      ..externalId = json['external_id'] as String?;
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'completed': completed,
        'sort_order': sortOrder,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'external_id': externalId,
      };
}
