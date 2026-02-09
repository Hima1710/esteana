import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

/// عنصر ذكر واحد (نص + عدد مرات التكرار).
class DhikrItem {
  const DhikrItem({
    required this.textAr,
    required this.textEn,
    required this.count,
  });

  final String textAr;
  final String textEn;
  final int count;

  factory DhikrItem.fromJson(Map<String, dynamic> json) {
    return DhikrItem(
      textAr: json['textAr'] as String? ?? '',
      textEn: json['textEn'] as String? ?? '',
      count: (json['count'] as num?)?.toInt() ?? 1,
    );
  }
}

/// فئة أذكار (صباح، مساء، بعد الصلاة، نوم، توبة).
class DhikrCategory {
  const DhikrCategory({
    required this.id,
    required this.items,
    this.targetCount,
  });

  final String id;
  final List<DhikrItem> items;
  /// لبطاقة التوبة: الهدف اليومي (مثلاً 100 استغفار).
  final int? targetCount;

  factory DhikrCategory.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>? ?? [];
    return DhikrCategory(
      id: json['id'] as String? ?? '',
      targetCount: (json['targetCount'] as num?)?.toInt(),
      items: itemsList.map((e) => DhikrItem.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  bool get isTawba => id == 'tawba';
}

/// جذر ملف adhkar.json.
class AdhkarRoot {
  const AdhkarRoot({required this.categories});
  final List<DhikrCategory> categories;

  factory AdhkarRoot.fromJson(Map<String, dynamic> json) {
    final list = json['categories'] as List<dynamic>? ?? [];
    return AdhkarRoot(
      categories: list.map((e) => DhikrCategory.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

/// تحميل أذكار حصن المسلم من assets/data/adhkar.json.
Future<AdhkarRoot> loadAdhkarFromAssets() async {
  final str = await rootBundle.loadString('assets/data/adhkar.json');
  final map = jsonDecode(str) as Map<String, dynamic>;
  return AdhkarRoot.fromJson(map);
}
