import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_plus/share_plus.dart';
import 'package:isar/isar.dart';

import '../theme/app_theme.dart';
import '../hooks/use_l10n.dart';
import '../hooks/use_isar.dart';
import '../data/adhkar_data.dart';
import '../models/dhikr_day_progress.dart';
import '../services/dhikr_progress_service.dart';
import '../services/progress_system.dart';
import '../widgets/app_card.dart';
import '../widgets/luminous_effect.dart';
import '../generated/l10n/app_localizations.dart';

/// شاشة تفاصيل فئة الأذكار: قائمة تفاعلية، عداد لكل ذكر، هزّة عند الضغط، ربط بأثري، مشاركة.
class DhikrCategoryScreen extends HookWidget {
  const DhikrCategoryScreen({
    super.key,
    required this.category,
    required this.categoryTitle,
    required this.isTawba,
  });

  final DhikrCategory category;
  final String categoryTitle;
  final bool isTawba;

  @override
  Widget build(BuildContext context) {
    final l10n = useL10n();
    final isar = useIsar();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradient = AppGradients.gradientFor(theme.brightness);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    // عداد لكل عنصر — ValueNotifier كي يُعاد بناء البطاقة المضغوطة فقط لا الشاشة كلها
    final countNotifiers = useMemoized(
      () => category.items.map((e) => ValueNotifier<int>(e.count)).toList(),
    );
    final tawbaDefault = category.targetCount ?? 100;
    final tawbaCount = useState<int>(tawbaDefault);
    final tawbaCompleted = useState<bool>(false);
    final showTawbaMessage = useState<bool>(false);

    useEffect(() {
      getTodayProgress(isar, category.id).then((p) {
        if (p == null) return;
        final list = DhikrDayProgress.parseCounts(p.countsJson);
        if (category.isTawba && list.isNotEmpty) {
          tawbaCount.value = list[0];
        } else if (list.length == countNotifiers.length) {
          for (var i = 0; i < countNotifiers.length; i++) {
            countNotifiers[i].value = list[i];
          }
        }
      });
      return () {
        for (final n in countNotifiers) {
          n.dispose();
        }
      };
    }, []);

    void saveProgress() {
      if (category.isTawba) {
        saveTodayTawbaProgress(isar, tawbaCount.value);
      } else {
        saveTodayProgress(
          isar,
          category.id,
          countNotifiers.map((n) => n.value).toList(),
        );
      }
    }

    void onTap(int index) {
      LuminousEffect.trigger(context);
      ProgressSystem.addLuminousPieces(1);
      if (isTawba && category.items.isNotEmpty) {
        if (tawbaCount.value <= 0) return;
        tawbaCount.value = tawbaCount.value - 1;
        if (tawbaCount.value == 0) {
          tawbaCompleted.value = true;
          showTawbaMessage.value = true;
          ProgressSystem.recordGoodDeed(isar, categoryTitle);
        }
        saveProgress();
        return;
      }
      if (index < 0 || index >= countNotifiers.length) return;
      final notifier = countNotifiers[index];
      if (notifier.value <= 0) return;
      notifier.value = notifier.value - 1;
      if (notifier.value == 0) ProgressSystem.recordGoodDeed(isar, categoryTitle);
      saveProgress();
    }

    String textFor(DhikrItem item) => isArabic ? item.textAr : item.textEn;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(categoryTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: l10n.history,
            onPressed: () => _showHistorySheet(context, isar, category.id, l10n, theme),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: gradient),
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  if (showTawbaMessage.value && isTawba)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: AppCard(
                        icon: Icons.celebration_rounded,
                        title: l10n.tawbaCompletionMessage,
                        useTealTint: true,
                      ),
                    ),
              Expanded(
                child: isTawba && category.items.isNotEmpty
                    ? _buildTawbaContent(
                        context,
                        category.items.first,
                        tawbaCount.value,
                        category.targetCount ?? 100,
                        onTap: () => onTap(0),
                        onShare: () => _shareDhikr(l10n, textFor(category.items.first)),
                        colorScheme: colorScheme,
                        theme: theme,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        cacheExtent: 400,
                        itemCount: category.items.length,
                        itemBuilder: (context, index) {
                          final item = category.items[index];
                          return RepaintBoundary(
                            key: ValueKey(index),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _DhikrItemCard(
                                text: textFor(item),
                                countListenable: countNotifiers[index],
                                total: item.count,
                                onTap: () => onTap(index),
                                onShare: () => _shareDhikr(l10n, textFor(item)),
                                colorScheme: colorScheme,
                                theme: theme,
                              ),
                            ),
                          );
                        },
                      ),
                ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTawbaContent(
    BuildContext context,
    DhikrItem item,
    int current,
    int target,
    {required VoidCallback onTap, required VoidCallback onShare, required ColorScheme colorScheme, required ThemeData theme}
  ) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        _DhikrItemCard(
          text: Localizations.localeOf(context).languageCode == 'ar' ? item.textAr : item.textEn,
          count: current,
          total: target,
          onTap: onTap,
          onShare: onShare,
          colorScheme: colorScheme,
          theme: theme,
          isTawbaGoal: true,
        ),
      ],
    );
  }

  static void _showHistorySheet(BuildContext context, Isar isar, String categoryId, AppLocalizations l10n, ThemeData theme) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => FutureBuilder<List<({int dateKey, bool completed})>>(
        future: getCategoryHistory(isar, categoryId, days: 14),
        builder: (ctx, snap) {
          final list = snap.data ?? [];
          final colorScheme = theme.colorScheme;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.history,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (list.isEmpty)
                    Text(
                      '—',
                      style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.7)),
                    )
                  else
                    ...list.map((e) {
                      final d = DateTime(e.dateKey ~/ 10000, (e.dateKey % 10000) ~/ 100, e.dateKey % 100);
                      final dateStr = '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Icon(
                              e.completed ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                              size: 22,
                              color: e.completed ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.4),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              dateStr,
                              style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static void _shareDhikr(AppLocalizations l10n, String text) {
    SharePlus.instance.share(ShareParams(
      text: '$text\n— ${l10n.appTitle}',
      subject: l10n.dailyWisdom,
    ));
  }
}

/// شكل ثابت للبطاقة لتقليل إنشاء كائنات في كل build.
final _dhikrCardShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(kShapeRadius),
);

class _DhikrItemCard extends StatelessWidget {
  const _DhikrItemCard({
    required this.text,
    required this.total,
    required this.onTap,
    required this.onShare,
    required this.colorScheme,
    required this.theme,
    this.countListenable,
    this.count,
    this.isTawbaGoal = false,
  }) : assert(countListenable != null || count != null, 'إما countListenable أو count مطلوب');

  final String text;
  final ValueListenable<int>? countListenable;
  final int? count;
  final int total;
  final VoidCallback onTap;
  final VoidCallback onShare;
  final ColorScheme colorScheme;
  final ThemeData theme;
  final bool isTawbaGoal;

  @override
  Widget build(BuildContext context) {
    if (countListenable != null) {
      return ValueListenableBuilder<int>(
        valueListenable: countListenable!,
        builder: (context, value, _) => _buildContent(context, value),
      );
    }
    return _buildContent(context, count!);
  }

  Widget _buildContent(BuildContext context, int count) {
    return Card.filled(
      shape: _dhikrCardShape,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Material(
                    color: count > 0 ? colorScheme.primaryContainer.withValues(alpha: 0.6) : colorScheme.surfaceContainerHighest,
                    shape: _dhikrCardShape,
                    child: InkWell(
                      onTap: count > 0 ? onTap : null,
                      borderRadius: BorderRadius.circular(kShapeRadius),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Text(
                            '$count',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: count > 0 ? colorScheme.onPrimaryContainer : colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (isTawbaGoal) ...[
                  const SizedBox(width: 8),
                  Text(
                    '/ $total',
                    style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.7)),
                  ),
                ],
                const SizedBox(width: 12),
                Material(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.6),
                  shape: _dhikrCardShape,
                  child: InkWell(
                    onTap: onShare,
                    borderRadius: BorderRadius.circular(kShapeRadius),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconTheme(data: IconThemeData(size: 20, color: colorScheme.onPrimaryContainer), child: const Icon(Icons.share_rounded)),
                          const SizedBox(width: 6),
                          Text(
                            AppLocalizations.of(context)!.share,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
