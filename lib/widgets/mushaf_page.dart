import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/mushaf_api_service.dart';
import '../theme/app_theme.dart';

/// رسام فوق صفحة المصحف — جاهز لرسم تظليل الآيات عند توفر الإحداثيات.
/// الافتراضي لا يرسم شيئاً؛ يمكن تمديده أو استبداله برسام يخصك.
class MushafOverlayPainter extends CustomPainter {
  const MushafOverlayPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // جاهز للرسم فوق الآيات — override في subclass أو استبدل بـ painter مخصص
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// رسام تظليل تجريبي: يرسم طبقة شفافة بلون المعلم فوق الصفحة لتجربة التظليل.
/// عند توفر إحداثيات الآيات لاحقاً يمكن استبداله برسم مناطق فقط.
class MushafHighlightOverlayPainter extends CustomPainter {
  const MushafHighlightOverlayPainter({this.highlightColor});

  final Color? highlightColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (highlightColor == null) return;
    final paint = Paint()
      ..color = highlightColor!.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant MushafHighlightOverlayPainter oldDelegate) =>
      oldDelegate.highlightColor != highlightColor;
}

/// صفحة مصحف موحدة: صور فقط (مصحف المدينة V4). Stack — صورة ثم CustomPainter للتظليل.
/// عند التحميل أو الخطأ: هيكل بلون الورق + CircularProgressIndicator فقط (بدون نصوص).
class MushafPage extends StatelessWidget {
  const MushafPage({
    super.key,
    required this.pageNumber,
    this.imageUrl,
    this.localFilePath,
    this.overlayPainter,
    this.fit = BoxFit.contain,
  });

  /// رقم الصفحة (1..604). يُستخدم لبناء الرابط إن لم يُمرَّر [imageUrl].
  final int pageNumber;

  /// رابط الصورة. إن كان null يُستخدم [mushafPageImageUrl](pageNumber).
  final String? imageUrl;

  /// مسار ملف محلي للصفحة (إن وُجد) — يُعطى أولوية على الشبكة.
  final String? localFilePath;

  /// رسام اختياري للطبقة الثانية (رسم فوق الآيات).
  final CustomPainter? overlayPainter;

  /// احتواء الصورة دون تمطيط.
  final BoxFit fit;

  String get _url {
    final u = imageUrl ?? mushafPageImageUrl(pageNumber);
    return u;
  }

  @override
  Widget build(BuildContext context) {
    final painter = overlayPainter ?? const MushafOverlayPainter();
    final useLocal = localFilePath != null && localFilePath!.isNotEmpty && File(localFilePath!).existsSync();

    if (useLocal) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.file(File(localFilePath!), fit: fit),
          Positioned.fill(
            child: CustomPaint(size: Size.infinite, painter: painter),
          ),
        ],
      );
    }

    final url = _url;
    if (url.isEmpty) {
      if (kDebugMode) debugPrint('[Mushaf] صفحة $pageNumber: رابط فارغ → Skeleton');
      return _buildSkeleton(context);
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: url,
          fit: fit,
          placeholder: (context, u) => _buildSkeleton(context),
          errorWidget: (context, u, error) {
            if (kDebugMode) debugPrint('[Mushaf] صفحة $pageNumber فشل التحميل: url=$u error=$error');
            return _buildSkeleton(context);
          },
        ),
        Positioned.fill(
          child: CustomPaint(
            size: Size.infinite,
            painter: painter,
          ),
        ),
      ],
    );
  }

  /// هيكل صفحة فارغ بلون الورق + مؤشر تحميل (بدون نصوص).
  Widget _buildSkeleton(BuildContext context) {
    return Container(
      color: AppColors.mushafPaper,
      child: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
