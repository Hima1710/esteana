import 'package:flutter/material.dart';

import '../../models/assignment.dart';
import '../../theme/app_theme.dart';
import '../../widgets/assignment_coordinates_painter.dart';
import '../../widgets/mushaf_page.dart';
import '../../widgets/mushaf_teacher_toolbar.dart' show colorForAssignmentType;

/// شاشة عرض مهمة واحدة: صفحة المصحف مع التظليل حسب الإحداثيات المخزنة.
class AssignmentViewerScreen extends StatelessWidget {
  const AssignmentViewerScreen({
    super.key,
    required this.assignment,
  });

  final Assignment assignment;

  @override
  Widget build(BuildContext context) {
    final highlightColor = colorForAssignmentType(assignment.type);
    final painter = AssignmentCoordinatesPainter(
      coordinates: assignment.coordinates,
      highlightColor: highlightColor,
    );
    final title = assignment.title ?? '${assignment.type} — صفحة ${assignment.pageNumber}';
    return Scaffold(
      backgroundColor: AppColors.mushafPaper,
      appBar: AppBar(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(kShapeRadius),
            child: MushafPage(
              pageNumber: assignment.pageNumber,
              overlayPainter: painter,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
