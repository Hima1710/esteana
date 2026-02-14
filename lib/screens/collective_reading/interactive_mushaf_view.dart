import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../quran/quran_provider.dart';
import '../../services/mushaf_storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/assignment_coordinates_painter.dart';
import '../../widgets/mushaf_page.dart';

/// مصحف تفاعلي: صورة في الخلفية، فوقها طبقة رسم (CustomPainter) فقط للمستطيلات،
/// ثم طبقة شفافة لللمس. لا تُغيّر اللمسات خلفية الصورة؛ تُضاف مستطيلات إلى [onAddRect].
class InteractiveMushafView extends HookWidget {
  const InteractiveMushafView({
    super.key,
    required this.quran,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
    required this.currentVerseKey,
    required this.pastVerseKeys,
    this.onVerseTap,
    this.canControl = true,
    this.highlightColor,
    this.highlightedRectsByPage = const {},
    this.onAddRect,
    this.drawingMode = false,
  });

  final QuranProvider quran;
  final PageController pageController;
  final ValueNotifier<int> currentPage;
  final void Function(int page) onPageChanged;
  final String? currentVerseKey;
  final Set<String> pastVerseKeys;
  final void Function(String verseKey, String status)? onVerseTap;
  final bool canControl;
  final Color? highlightColor;
  /// مستطيلات التظليل لكل صفحة (نسب 0..1 من الصورة).
  final Map<int, List<Map<String, double>>> highlightedRectsByPage;
  /// يُستدعى عند إضافة مستطيل تظليل جديد (الرسم باللمس).
  final void Function(int pageNumber, Map<String, double> rect)? onAddRect;
  /// عندما true: السحب على الصفحة يرسم ولا يقلب الصفحة (تعطيل تقليب PageView).
  final bool drawingMode;

  @override
  Widget build(BuildContext context) {
    final preventPageFlip = drawingMode && onAddRect != null && highlightColor != null;
    return Container(
      color: AppColors.mushafPaper,
      child: PageView.builder(
        controller: pageController,
        physics: !canControl || preventPageFlip
            ? const NeverScrollableScrollPhysics()
            : null,
        itemCount: quran.totalPages,
        onPageChanged: (index) {
          final page = index + 1;
          currentPage.value = page;
          onPageChanged(page);
        },
        itemBuilder: (context, index) {
          final pageNumber = index + 1;
          final rects = highlightedRectsByPage[pageNumber] ?? [];
          final localPath = MushafStorageService.getLocalPathForPage(pageNumber);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Center(
              child: AspectRatio(
                aspectRatio: kMushafImageAspectRatio,
                child: _MushafPageWithHighlight(
                  quran: quran,
                  pageNumber: pageNumber,
                  localFilePath: localPath,
                  highlightColor: highlightColor,
                  rects: rects,
                  canControl: canControl,
                  drawingMode: drawingMode,
                  onAddRect: onAddRect != null ? (r) => onAddRect!(pageNumber, r) : null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MushafPageWithHighlight extends StatefulWidget {
  const _MushafPageWithHighlight({
    required this.quran,
    required this.pageNumber,
    this.localFilePath,
    this.highlightColor,
    this.rects = const [],
    this.canControl = true,
    this.drawingMode = false,
    this.onAddRect,
  });

  final QuranProvider quran;
  final int pageNumber;
  final String? localFilePath;
  final Color? highlightColor;
  final List<Map<String, double>> rects;
  final bool canControl;
  final bool drawingMode;
  final void Function(Map<String, double> rect)? onAddRect;

  @override
  State<_MushafPageWithHighlight> createState() => _MushafPageWithHighlightState();
}

class _MushafPageWithHighlightState extends State<_MushafPageWithHighlight> {
  Offset? _panStart;

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.quran.pageImageUrl(widget.pageNumber);
    final hasDrawingLayer = widget.highlightColor != null && (widget.rects.isNotEmpty || widget.onAddRect != null);
    final overlayPainter = hasDrawingLayer && widget.rects.isNotEmpty
        ? HighlightRectsPainter(
            rects: widget.rects,
            highlightColor: widget.highlightColor!,
          )
        : null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(kShapeRadius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          MushafPage(
            pageNumber: widget.pageNumber,
            imageUrl: imageUrl.isEmpty ? null : imageUrl,
            localFilePath: widget.localFilePath,
            overlayPainter: overlayPainter,
            fit: BoxFit.contain,
          ),
          if (widget.canControl && widget.drawingMode && widget.highlightColor != null && widget.onAddRect != null)
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final size = Size(constraints.maxWidth, constraints.maxHeight);
                  final contentRect = contentRectForContain(size, kMushafImageAspectRatio);
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onPanStart: (d) {
                      _panStart = d.localPosition;
                    },
                    onPanEnd: (d) {
                      final end = d.localPosition;
                      final start = _panStart;
                      _panStart = null;
                      if (start == null) return;
                      final left = ((start.dx - contentRect.left) / contentRect.width).clamp(0.0, 1.0);
                      final top = ((start.dy - contentRect.top) / contentRect.height).clamp(0.0, 1.0);
                      final endLeft = ((end.dx - contentRect.left) / contentRect.width).clamp(0.0, 1.0);
                      final endTop = ((end.dy - contentRect.top) / contentRect.height).clamp(0.0, 1.0);
                      final rectLeft = left < endLeft ? left : endLeft;
                      final rectTop = top < endTop ? top : endTop;
                      final rectWidth = (endLeft - left).abs().clamp(0.02, 1.0);
                      final rectHeight = (endTop - top).abs().clamp(0.02, 1.0);
                      widget.onAddRect!({
                        'left': rectLeft,
                        'top': rectTop,
                        'width': rectWidth,
                        'height': rectHeight,
                      });
                    },
                    onTapUp: (d) {
                      final local = d.localPosition;
                      final left = ((local.dx - contentRect.left) / contentRect.width).clamp(0.0, 1.0);
                      final top = ((local.dy - contentRect.top) / contentRect.height).clamp(0.0, 1.0);
                      const small = 0.05;
                      widget.onAddRect!({
                        'left': (left - small / 2).clamp(0.0, 1.0),
                        'top': (top - small / 2).clamp(0.0, 1.0),
                        'width': small,
                        'height': small,
                      });
                    },
                    child: const SizedBox.expand(),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
