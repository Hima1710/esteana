import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// بطاقة موحدة: تدرج Teal، حواف 24dp، أيقونة، عنوان، وصف/قيمة اختياري، شريط تقدم اختياري.
/// متوافقة مع Material 3 ونظام الألوان من الثيم.
class AppCard extends StatelessWidget {
  static final _shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius));

  const AppCard({
    super.key,
    this.icon,
    this.title,
    this.subtitle,
    this.value,
    this.progress,
    this.progressTitle,
    this.progressLabel,
    this.child,
    this.onTap,
    this.color,
    this.useTealTint = true,
  });

  final IconData? icon;
  final String? title;
  final String? subtitle;
  /// قيمة عددية تظهر بخط أكبر (مثل إجمالي القطع النورانية).
  final String? value;
  /// 0.0 .. 1.0؛ إن وُجد يُرسم شريط تقدم أسفل المحتوى.
  final double? progress;
  /// عنوان يسار شريط التقدم (مثل "أذكار اليوم").
  final String? progressTitle;
  /// نص يمين شريط التقدم (مثل "2 / 5").
  final String? progressLabel;
  final Widget? child;
  final VoidCallback? onTap;
  /// لون الخلفية؛ إن لم يُحدد يُستخدم primaryContainer مع شفافية حسب [useTealTint].
  final Color? color;
  /// إن true يُطبَّق primaryContainer.withValues(alpha: 0.5–0.6) للخلفية.
  final bool useTealTint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bgColor = color ?? (useTealTint ? colorScheme.primaryContainer.withValues(alpha: 0.6) : colorScheme.surfaceContainerLow);

    Widget content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null || title != null || value != null)
            Row(
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(alpha: useTealTint ? 0.8 : 0.5),
                      borderRadius: BorderRadius.circular(kShapeRadius),
                    ),
                    child: Icon(icon, size: 28, color: colorScheme.onPrimaryContainer),
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null && title!.isNotEmpty)
                        Text(
                          title!,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      if (subtitle != null && subtitle!.isNotEmpty) ...[
                        if (title != null) const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                      if (value != null && value!.isNotEmpty) ...[
                        if (title != null || subtitle != null) const SizedBox(height: 4),
                        Text(
                          value!,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          if (child != null) ...[
            if (icon != null || title != null || value != null) const SizedBox(height: 12),
            child!,
          ],
          if (progress != null) ...[
            if (child != null || icon != null || title != null) const SizedBox(height: 12),
            if (progressTitle != null || progressLabel != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (progressTitle != null && progressTitle!.isNotEmpty)
                    Text(
                      progressTitle!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  if (progressLabel != null && progressLabel!.isNotEmpty)
                    Text(
                      progressLabel!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                ],
              ),
            if (progressTitle != null || progressLabel != null) const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress!.clamp(0.0, 1.0),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ],
        ],
      ),
    );

    // elevation: 0 وحد خفيف لتقليل عبء الـ Raster (بدل ظلال Card الافتراضية).
    final shapeWithBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kShapeRadius),
      side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2), width: 0.5),
    );
    if (onTap != null) {
      return Card(
        color: bgColor,
        shape: shapeWithBorder,
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(kShapeRadius),
          child: content,
        ),
      );
    }
    return Card(
      color: bgColor,
      shape: shapeWithBorder,
      elevation: 0,
      child: content,
    );
  }
}
