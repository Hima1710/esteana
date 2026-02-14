import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// ألوان التظليل المتاحة للمعلم (شريط أدوات المعلم).
const List<Color?> kMushafHighlightColors = [
  null, // إزالة التظليل
  Color(0xFF2E7D32), // أخضر — لوح
  Color(0xFFF9A825), // أصفر — ماضي
  Color(0xFFEF6C00), // برتقالي
  Color(0xFFC62828), // أحمر
  Color(0xFF1565C0), // أزرق
  Color(0xFFAD1457), // وردي
];

/// لون الأخضر (لوح) ولون الأصفر (ماضي) لربط التظليل بنوع المهمة.
const Color kLohColor = Color(0xFF2E7D32);
const Color kMadiColor = Color(0xFFF9A825);

/// يُرجع نوع المهمة من لون التظليل: أخضر → لوح، أصفر → ماضي، غير ذلك null.
String? assignmentTypeFromColor(Color? color) {
  if (color == null) return null;
  if (color == kLohColor) return 'لوح';
  if (color == kMadiColor) return 'ماضي';
  return null;
}

/// هل اللون الحالي يُعتبر «مهمة قابلة للحفظ» (لوح أو ماضي).
bool isAssignmentColor(Color? color) =>
    assignmentTypeFromColor(color) != null;

/// لون التظليل حسب نوع المهمة (للعرض في فهرس الواجبات وعارض المهمة).
Color colorForAssignmentType(String type) {
  switch (type) {
    case 'لوح':
      return kLohColor;
    case 'ماضي':
      return kMadiColor;
    case 'تنبيه':
      return const Color(0xFFEF6C00);
    default:
      return kLohColor;
  }
}

/// شريط أدوات المعلم: اختيار لون التظليل فوق صفحة المصحف.
class MushafTeacherToolbar extends StatelessWidget {
  const MushafTeacherToolbar({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  final Color? selectedColor;
  final void Function(Color? color) onColorSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.98),
        borderRadius: BorderRadius.circular(kShapeRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(
              Icons.brush_rounded,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          ...kMushafHighlightColors.map((color) {
            final isSelected = color == selectedColor;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _ColorChip(
                color: color,
                selected: isSelected,
                onTap: () => onColorSelected(color),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ColorChip extends StatelessWidget {
  const _ColorChip({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color? color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color ?? Colors.transparent,
            border: Border.all(
              color: color == null
                  ? Theme.of(context).colorScheme.outline
                  : (selected ? Colors.black87 : Colors.transparent),
              width: selected ? 2.5 : 1,
            ),
            boxShadow: color != null && selected
                ? [
                    BoxShadow(
                      color: color!.withValues(alpha: 0.5),
                      blurRadius: 6,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: color == null
              ? Icon(
                  Icons.clear_rounded,
                  size: 18,
                  color: Theme.of(context).colorScheme.outline,
                )
              : null,
        ),
      ),
    );
  }
}
