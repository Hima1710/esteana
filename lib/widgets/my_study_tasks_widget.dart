import 'package:flutter/material.dart';

import '../generated/l10n/app_localizations.dart';
import '../models/assignment.dart';
import '../screens/assignments/assignment_viewer_screen.dart';
import '../services/assignments_service.dart';
import '../theme/app_theme.dart';
import 'mushaf_teacher_toolbar.dart';

/// ويدجت «مهامي الدراسية»: قائمة مهام الطالب من جدول assignments (الأحدث أولاً).
/// كل بطاقة بأيقونة ملونة حسب النوع؛ عند الضغط تُفتح شاشة القارئ مع التظليل.
class MyStudyTasksWidget extends StatefulWidget {
  const MyStudyTasksWidget({
    super.key,
    required this.studentId,
    required this.l10n,
  });

  final String studentId;
  final AppLocalizations l10n;

  @override
  State<MyStudyTasksWidget> createState() => _MyStudyTasksWidgetState();
}

class _MyStudyTasksWidgetState extends State<MyStudyTasksWidget> {
  List<Assignment>? _assignments;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _error = null;
      _assignments = null;
    });
    try {
      final list = await fetchAssignmentsForStudent(widget.studentId);
      if (mounted) setState(() => _assignments = list);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, color: Theme.of(context).colorScheme.error, size: 40),
              const SizedBox(height: 8),
              Text(widget.l10n.noResults, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              const SizedBox(height: 8),
              TextButton(onPressed: _load, child: Text(widget.l10n.cancel)),
            ],
          ),
        ),
      );
    }
    if (_assignments == null) {
      return const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()));
    }
    final list = _assignments!;
    if (list.isEmpty) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.assignment_outlined, size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(height: 12),
              Text(widget.l10n.noAssignments, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final a = list[index];
        return _AssignmentCard(
          assignment: a,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => AssignmentViewerScreen(
                  assignment: a,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _AssignmentCard extends StatelessWidget {
  const _AssignmentCard({
    required this.assignment,
    required this.onTap,
  });

  final Assignment assignment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = colorForAssignmentType(assignment.type);
    final dateStr = _formatDate(assignment.createdAt);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(kShapeRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.menu_book_rounded, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assignment.title ?? '${assignment.type} — صفحة ${assignment.pageNumber}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${assignment.type} · ص ${assignment.pageNumber} · $dateStr',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return 'اليوم';
    }
    return '${d.day}/${d.month}/${d.year}';
  }
}
