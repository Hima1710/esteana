/// نوع أيقونة المناسبة (ديناميكي حسب المناسبة).
enum OccasionIconType {
  crescent, // رمضان، الفطر، رأس السنة
  kaaba,   // عرفة، الأضحى
  book,    // المولد النبوي
}

/// مناسبة إسلامية: تاريخ هجري ثابت واسم وعرض.
class Occasion {
  const Occasion({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.hijriMonth,
    required this.hijriDay,
    this.durationDays = 1,
    required this.iconType,
  });

  final String id;
  final String nameAr;
  final String nameEn;
  /// الشهر الهجري 1..12
  final int hijriMonth;
  /// اليوم في الشهر 1..30
  final int hijriDay;
  /// عدد أيام المناسبة (مثلاً رمضان 30).
  final int durationDays;
  final OccasionIconType iconType;

  String name(String locale) => locale.startsWith('ar') ? nameAr : nameEn;
}
