import 'package:flutter/material.dart';

/// نسبة عرض الصورة إلى ارتفاعها (عرض/ارتفاع) لصفحة مصحف المدينة.
/// تُستخدم لاحتساب مستطيل المحتوى عند BoxFit.contain حتى تُرسم النسب على الصورة فقط.
const double kMushafImageAspectRatio = 1024 / 1520;

/// يُرجع مستطيل المحتوى (منطقة الصورة الفعلية) عند تطبيق BoxFit.contain
/// داخل [outputSize] لصورة بنسبة [imageAspectRatio].
Rect contentRectForContain(Size outputSize, double imageAspectRatio) {
  final outputRatio = outputSize.width / outputSize.height;
  if (imageAspectRatio >= outputRatio) {
    final contentWidth = outputSize.width;
    final contentHeight = outputSize.width / imageAspectRatio;
    final contentTop = (outputSize.height - contentHeight) * 0.5;
    return Rect.fromLTWH(0, contentTop, contentWidth, contentHeight);
  } else {
    final contentHeight = outputSize.height;
    final contentWidth = outputSize.height * imageAspectRatio;
    final contentLeft = (outputSize.width - contentWidth) * 0.5;
    return Rect.fromLTWH(contentLeft, 0, contentWidth, contentHeight);
  }
}

/// يرسم التظليل فوق صفحة المصحف حسب الإحداثيات المخزنة (jsonb).
/// الإحداثيات تُخزَّن وتُفسَّر كنسب مئوية (0..1) من أبعاد الصورة، وليس بيكسلات،
/// كي يظهر التظليل في مكانه الصحيح على كل أحجام الشاشات.
///
/// يدعم:
/// - [fullPage]: true — تظليل كامل مساحة الصورة (داخل مستطيل المحتوى فقط).
/// - [regions]: قائمة مناطق، كل عنصر: left, top, width, height (نسب 0..1 من الصورة).
///
/// [imageAspectRatio]: نسبة عرض/ارتفاع صورة المصحف. إن لم تُمرَّر تُستخدم الثابتة.
class AssignmentCoordinatesPainter extends CustomPainter {
  AssignmentCoordinatesPainter({
    required this.coordinates,
    required this.highlightColor,
    this.imageAspectRatio = kMushafImageAspectRatio,
  });

  final Map<String, dynamic>? coordinates;
  final Color highlightColor;

  /// نسبة عرض الصورة إلى ارتفاعها (عرض/ارتفاع) لاحتساب مستطيل المحتوى مع BoxFit.contain.
  final double imageAspectRatio;

  @override
  void paint(Canvas canvas, Size size) {
    if (coordinates == null || coordinates!.isEmpty) return;

    final contentRect = contentRectForContain(size, imageAspectRatio);
    final paint = Paint()
      ..color = highlightColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    final fullPage = coordinates!['fullPage'] as bool? ?? false;
    if (fullPage) {
      canvas.drawRect(contentRect, paint);
      return;
    }

    final regions = coordinates!['regions'] as List<dynamic>?;
    if (regions == null || regions.isEmpty) return;

    for (final r in regions) {
      final map = r is Map<String, dynamic> ? r : (r is Map ? Map<String, dynamic>.from(r) : null);
      if (map == null) continue;
      final left = (map['left'] as num?)?.toDouble() ?? 0.0;
      final top = (map['top'] as num?)?.toDouble() ?? 0.0;
      final width = (map['width'] as num?)?.toDouble() ?? 1.0;
      final height = (map['height'] as num?)?.toDouble() ?? 1.0;
      final rect = Rect.fromLTWH(
        contentRect.left + contentRect.width * left,
        contentRect.top + contentRect.height * top,
        contentRect.width * width,
        contentRect.height * height,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant AssignmentCoordinatesPainter oldDelegate) =>
      oldDelegate.coordinates != coordinates ||
      oldDelegate.highlightColor != highlightColor ||
      oldDelegate.imageAspectRatio != imageAspectRatio;
}

/// يرسم قائمة مستطيلات تظليل فقط (نسب 0..1 من الصورة) فوق منطقة المحتوى.
/// يُستخدم مع طبقة لمس منفصلة؛ لا يغيّر خلفية الصورة.
class HighlightRectsPainter extends CustomPainter {
  HighlightRectsPainter({
    required this.rects,
    required this.highlightColor,
    this.imageAspectRatio = kMushafImageAspectRatio,
  });

  final List<Map<String, double>> rects;
  final Color highlightColor;
  final double imageAspectRatio;

  @override
  void paint(Canvas canvas, Size size) {
    if (rects.isEmpty) return;
    final contentRect = contentRectForContain(size, imageAspectRatio);
    final paint = Paint()
      ..color = highlightColor.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;
    for (final r in rects) {
      final left = (r['left'] ?? 0.0).clamp(0.0, 1.0);
      final top = (r['top'] ?? 0.0).clamp(0.0, 1.0);
      final width = (r['width'] ?? 1.0).clamp(0.0, 1.0);
      final height = (r['height'] ?? 1.0).clamp(0.0, 1.0);
      final rect = Rect.fromLTWH(
        contentRect.left + contentRect.width * left,
        contentRect.top + contentRect.height * top,
        contentRect.width * width,
        contentRect.height * height,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant HighlightRectsPainter oldDelegate) =>
      oldDelegate.rects != rects || oldDelegate.highlightColor != highlightColor;
}
