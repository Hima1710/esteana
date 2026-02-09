import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';

import '../../models/daily_task.dart';
import '../../models/action_of_the_day_entry.dart';
import '../../hooks/use_isar.dart';
import '../../hooks/use_l10n.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/locale_digits.dart';
import '../../services/seed_service.dart';
import '../../services/luminous_service.dart';
import '../../widgets/app_card.dart';
import '../../providers/auth_provider.dart';

/// التابة الثانية — أثري: Filled Card ملونة، شعار عريض، شريط تقدم نحيف.
class AthariTab extends HookWidget {
  const AthariTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = useL10n();
    final isar = useIsar();
    final tasksSnapshot = useStream(useMemoized(() => isar.dailyTasks.where().watch(fireImmediately: true)));
    final tasks = tasksSnapshot.data ?? <DailyTask>[];
    final completedCount = tasks.where((t) => t.completed).length;
    final totalCount = tasks.length;
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    final weeklyDoneCount = tasks
        .where((t) => t.completed && t.updatedAt != null && t.updatedAt!.isAfter(weekAgo))
        .length;

    final luminousStream = useMemoized(LuminousService.watchTotal);
    final luminousSnapshot = useStream(luminousStream);
    final luminousTotal = luminousSnapshot.data ?? 0;

    final gradient = AppGradients.gradientFor(Theme.of(context).brightness);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(gradient: gradient),
      child: SafeArea(
        child: CustomScrollView(
          cacheExtent: 400,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _AthariHeader(),
                    _GuestSyncBanner(),
                    const SizedBox(height: 20),
                    const _TodayChallengeCard(),
                    const SizedBox(height: 16),
                    _ProgressBar(progress: progress),
                    const SizedBox(height: 6),
                    Text(
                      l10n.progressMsg(weeklyDoneCount).toLocaleDigits(Localizations.localeOf(context)),
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _LuminousPiecesRow(
                      total: luminousTotal,
                      l10n: l10n,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.myDailyTasks,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.95),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            _DailyTasksSliver(
              tasks: tasks,
              isLoading: !tasksSnapshot.hasData,
              isar: isar,
              l10n: l10n,
            ),
          ],
        ),
      ),
    );
  }
}

class _GuestSyncBanner extends StatelessWidget {
  const _GuestSyncBanner();

  @override
  Widget build(BuildContext context) {
    final isGuest = context.select<AuthProvider, bool>((p) => p.isGuest);
    if (!isGuest) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        color: colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              IconTheme(data: IconThemeData(size: 20, color: colorScheme.primary), child: const Icon(Icons.info_outline_rounded)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.guestSyncMessage,
                  style: TextStyle(fontSize: 13, color: colorScheme.onSurface),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AthariHeader extends StatelessWidget {
  const _AthariHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Card.filled(
      color: colorScheme.primaryContainer.withValues(alpha: 0.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Center(
          child: Text(
            l10n.actionTitle,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimaryContainer,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _TodayChallengeCard extends HookWidget {
  const _TodayChallengeCard();

  @override
  Widget build(BuildContext context) {
    final l10n = useL10n();
    final isar = useIsar();
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final key = useMemoized(() => todayKey());
    final stream = useMemoized(() => isar.actionOfTheDayEntrys.filter().dateKeyEqualTo(key).watch(fireImmediately: true));
    final snapshot = useStream(stream);
    final colorScheme = Theme.of(context).colorScheme;

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Card.filled(
        color: colorScheme.primaryContainer.withValues(alpha: 0.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius)),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final entry = snapshot.data!.first;
    final challengeTitle = isArabic ? entry.titleAr : entry.titleEn;

    return Card.filled(
      color: colorScheme.primaryContainer.withValues(alpha: 0.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconTheme(data: IconThemeData(color: colorScheme.primary, size: 28), child: const Icon(Icons.emoji_events_rounded)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.actionOfDay,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onPrimaryContainer),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              challengeTitle,
              style: TextStyle(fontSize: 15, height: 1.4, color: colorScheme.onPrimaryContainer),
            ),
            if (!entry.completed) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _markDone(isar, entry),
                  icon: const Icon(Icons.check_rounded, size: 20),
                  label: Text(l10n.done),
                ),
              ),
            ] else
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    IconTheme(data: IconThemeData(color: colorScheme.primary, size: 20), child: const Icon(Icons.check_circle_rounded)),
                    const SizedBox(width: 8),
                    Text(
                      l10n.done,
                      style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onPrimaryContainer),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _markDone(Isar isar, ActionOfTheDayEntry entry) async {
    entry.completed = true;
    entry.completedAt = DateTime.now();
    await isar.writeTxn(() async => await isar.actionOfTheDayEntrys.put(entry));
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: progress,
          minHeight: 4,
          borderRadius: BorderRadius.circular(2),
          backgroundColor: colorScheme.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
        ),
      ],
    );
  }
}

class _LuminousPiecesRow extends StatelessWidget {
  const _LuminousPiecesRow({required this.total, required this.l10n});

  final int total;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      icon: Icons.lightbulb_rounded,
      title: l10n.luminousPieces,
      value: total.toString().toLocaleDigits(Localizations.localeOf(context)),
      useTealTint: true,
    );
  }
}

/// شكل ثابت لبطاقات المهام والحمولة والفراغ.
final _taskCardShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius));

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.title,
    required this.completed,
    required this.leadingIcon,
    required this.onToggle,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final bool completed;
  final IconData leadingIcon;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Card(
      shape: _taskCardShape,
      color: completed
          ? colorScheme.surfaceContainerHighest
          : colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onToggle,
                borderRadius: BorderRadius.circular(kShapeRadius),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: completed
                            ? colorScheme.primary.withValues(alpha: 0.2)
                            : colorScheme.primaryContainer.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(kShapeRadius),
                      ),
                      child: IconTheme(
                        data: IconThemeData(
                          size: 22,
                          color: completed
                              ? colorScheme.primary.withValues(alpha: 0.9)
                              : colorScheme.onPrimaryContainer,
                        ),
                        child: Icon(leadingIcon),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              decoration: completed ? TextDecoration.lineThrough : null,
                              decorationColor: colorScheme.onSurface.withValues(alpha: 0.6),
                              color: completed
                                  ? colorScheme.onSurface.withValues(alpha: 0.7)
                                  : colorScheme.onSurface,
                            ),
                          ),
                          if (subtitle != null && subtitle!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              subtitle!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.75),
                                decoration: completed ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Checkbox(
              value: completed,
              onChanged: (_) => onToggle(),
              activeColor: colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyTasksSliver extends StatelessWidget {
  const _DailyTasksSliver({
    required this.tasks,
    required this.isLoading,
    required this.isar,
    required this.l10n,
  });

  final List<DailyTask> tasks;
  final bool isLoading;
  final Isar isar;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (isLoading) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: _taskCardShape,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator(color: colorScheme.primary)),
            ),
          ),
        ),
      );
    }
    if (tasks.isEmpty) {
      final theme = Theme.of(context);
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card.filled(
            shape: _taskCardShape,
            color: colorScheme.surfaceContainerHigh,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              child: Row(
                children: [
                  IconTheme(
                    data: IconThemeData(size: 40, color: colorScheme.primary.withValues(alpha: 0.8)),
                    child: const Icon(Icons.check_circle_outline_rounded),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      l10n.noTasksToday,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.85),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final task = tasks[index];
            return RepaintBoundary(
              key: ValueKey(task.id),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _TaskTile(
                  title: _taskDisplayTitle(l10n, task),
                  subtitle: task.description,
                  completed: task.completed,
                  leadingIcon: _taskIcon(task),
                  onToggle: () {
                    HapticFeedback.lightImpact();
                    _toggleTask(isar, task, !task.completed);
                  },
                ),
              ),
            );
          },
          childCount: tasks.length,
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
        ),
      ),
    );
  }

  String _taskDisplayTitle(AppLocalizations l10n, DailyTask task) {
    switch (task.externalId) {
      case 'daily_prayers':
        return l10n.dailyTaskDailyPrayers;
      case 'smile':
        return l10n.dailyTaskSmile;
      case 'gratitude':
        return l10n.dailyTaskGratitude;
      default:
        return task.title;
    }
  }

  IconData _taskIcon(DailyTask task) {
    switch (task.externalId) {
      case 'daily_prayers':
        return Icons.mosque_rounded;
      case 'smile':
        return Icons.emoji_emotions_outlined;
      case 'gratitude':
        return Icons.favorite_rounded;
      default:
        return Icons.check_circle_outline_rounded;
    }
  }

  Future<void> _toggleTask(Isar isar, DailyTask task, bool completed) async {
    task.completed = completed;
    task.updatedAt = DateTime.now();
    await isar.writeTxn(() async => await isar.dailyTasks.put(task));
  }
}
