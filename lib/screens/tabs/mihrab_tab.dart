import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';

import '../../theme/app_theme.dart';
import '../../utils/locale_digits.dart';
import '../../utils/time_format.dart';
import '../../hooks/use_l10n.dart';
import '../../hooks/use_isar.dart';
import '../../services/prayer_times_service.dart';
import '../../services/prayer_countdown_widget_service.dart';
import '../../services/dhikr_progress_service.dart' show getTodayDhikrSummary;
import '../../services/luminous_service.dart';
import '../../widgets/app_card.dart';
import '../../generated/l10n/app_localizations.dart';
import '../dhikr_screen.dart';
import '../mushaf/mushaf_screen.dart';
import '../qibla_screen.dart';
import '../prayer_month_screen.dart';

/// التابة الأولى — المحراب: العد التنازلي، جدول الصلاة، الوصول السريع (مصحف، أذكار، قبلة).
class MihrabTab extends HookWidget {
  const MihrabTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = useL10n();
    final isar = useIsar();
    final gradient = AppGradients.gradientFor(Theme.of(context).brightness);
    final timesFuture = useMemoized(() => PrayerTimesService.fetchTodayTimes(), []);

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(gradient: gradient),
      child: SafeArea(
        child: FutureBuilder<List<PrayerTimeEntry>>(
          future: timesFuture,
          builder: (context, snapshot) {
            final times = snapshot.data ?? PrayerTimesService.defaultTimes;
            final loading = !snapshot.hasData && snapshot.connectionState == ConnectionState.waiting;
            return CustomScrollView(
              cacheExtent: 400,
              slivers: [
                SliverToBoxAdapter(
                  child: RepaintBoundary(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _NextPrayerCountdown(
                            timeRemainingLabel: l10n.timeRemaining,
                            times: times,
                            isLoading: loading,
                          ),
                          const SizedBox(height: 20),
                          _PrayerTimesCard(
                            times: times,
                            isLoading: loading,
                            onFullMonthTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const PrayerMonthScreen(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _MasterTreasuryCard(l10n: l10n),
                          const SizedBox(height: 16),
                          _TodaysDhikrProgressBar(l10n: l10n, isar: isar),
                          const SizedBox(height: 20),
                          _QuickAccessRow(l10n: l10n),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// نص العد التنازلي فقط — يُحدَّث كل ثانية دون إعادة بناء بقية المحراب (سبب تقطيع التمرير سابقاً).
class _TickingCountdownText extends HookWidget {
  const _TickingCountdownText({
    required this.times,
    required this.timeRemainingLabel,
  });

  final List<PrayerTimeEntry> times;
  final String timeRemainingLabel;

  @override
  Widget build(BuildContext context) {
    final now = useState(DateTime.now());
    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (_) {
        now.value = DateTime.now();
      });
      return timer.cancel;
    }, []);

    final next = PrayerTimesService.getNextPrayer(now.value, times);
    final countdownStr = next != null
        ? PrayerTimesService.countdown(now.value, next.at)
        : '--:--:--';
    final locale = Localizations.localeOf(context);

    return RepaintBoundary(
      child: Text(
        '$timeRemainingLabel ${countdownStr.toLocaleDigits(locale)}',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.95),
          fontSize: 16,
        ),
      ),
    );
  }
}

/// العد التنازلي للصلاة القادمة — التحديث كل دقيقة للويدجت فقط؛ العد الثانوي في [_TickingCountdownText].
class _NextPrayerCountdown extends HookWidget {
  const _NextPrayerCountdown({
    required this.timeRemainingLabel,
    required this.times,
    this.isLoading = false,
  });

  final String timeRemainingLabel;
  final List<PrayerTimeEntry> times;
  final bool isLoading;

  static String _formatGregorian(DateTime date, String locale) {
    return DateFormat.yMMMd(locale).format(date);
  }

  static String _formatHijri(DateTime date, String locale) {
    final lang = locale.startsWith('ar') ? 'ar' : 'en';
    HijriCalendar.setLocal(lang);
    final h = HijriCalendar.fromDate(date);
    return '${h.hDay} ${h.getLongMonthName()} ${h.hYear}';
  }

  @override
  Widget build(BuildContext context) {
    final now60 = useState(DateTime.now());
    final lastWidgetUpdate = useRef<DateTime?>(null);

    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 60), (_) {
        now60.value = DateTime.now();
      });
      return timer.cancel;
    }, []);

    final next = PrayerTimesService.getNextPrayer(now60.value, times);

    if (!isLoading && next != null) {
      final shouldUpdate = lastWidgetUpdate.value == null ||
          DateTime.now().difference(lastWidgetUpdate.value!).inSeconds >= 60;
      if (shouldUpdate) {
        lastWidgetUpdate.value = DateTime.now();
        final locale = Localizations.localeOf(context);
        final localeStr = locale.toString();
        final dateGregorian = LocaleDigits.format(_formatGregorian(now60.value, localeStr), locale);
        final dateHijri = LocaleDigits.format(_formatHijri(now60.value, localeStr), locale);
        final l10n = AppLocalizations.of(context)!;
        updatePrayerCountdownWidget(
          labelNext: l10n.nextPrayer,
          dateGregorianLine: '${l10n.dateGregorian}: $dateGregorian',
          dateHijriLine: '${l10n.dateHijri}: $dateHijri',
          labelRemaining: timeRemainingLabel,
          today: now60.value,
          times: times,
        );
      }
    }

    return _NextPrayerHeader(
      nextNameAr: next?.nameAr,
      nextAt: next?.at,
      today: now60.value,
      isLoading: isLoading,
      timeRemainingLabel: timeRemainingLabel,
      countdownChild: _TickingCountdownText(
        times: times,
        timeRemainingLabel: timeRemainingLabel,
      ),
    );
  }
}

class _NextPrayerHeader extends StatelessWidget {
  const _NextPrayerHeader({
    this.nextNameAr,
    this.nextAt,
    required this.today,
    required this.timeRemainingLabel,
    required this.countdownChild,
    this.isLoading = false,
  });

  final String? nextNameAr;
  final DateTime? nextAt;
  final DateTime today;
  final String timeRemainingLabel;
  final Widget countdownChild;
  final bool isLoading;

  static String _formatGregorian(DateTime date, String locale) {
    return DateFormat.yMMMd(locale).format(date);
  }

  static String _formatHijri(DateTime date, String locale) {
    final lang = locale.startsWith('ar') ? 'ar' : 'en';
    HijriCalendar.setLocal(lang);
    final h = HijriCalendar.fromDate(date);
    return '${h.hDay} ${h.getLongMonthName()} ${h.hYear}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context);
    final localeStr = locale.toString();
    final dateGregorian = LocaleDigits.format(_formatGregorian(today, localeStr), locale);
    final dateHijri = LocaleDigits.format(_formatHijri(today, localeStr), locale);
    final nextLabel = isLoading
        ? '...'
        : (nextNameAr != null && nextAt != null
            ? '$nextNameAr — ${TimeFormat.formatTime(context, nextAt!.hour, nextAt!.minute).toLocaleDigits(locale)}'
            : '--');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerHigh : null,
        gradient: isDark ? null : AppGradients.tealGradientSoft,
        borderRadius: BorderRadius.circular(kShapeRadius),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.nextPrayer,
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      nextLabel,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${l10n.dateGregorian}: $dateGregorian',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.85),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${l10n.dateHijri}: $dateHijri',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.85),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          countdownChild,
        ],
      ),
    );
  }
}

class _PrayerTimesCard extends StatelessWidget {
  const _PrayerTimesCard({
    required this.times,
    this.isLoading = false,
    this.onFullMonthTap,
  });

  final List<PrayerTimeEntry> times;
  final bool isLoading;
  final VoidCallback? onFullMonthTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context);
    return Card.filled(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.prayerTimes,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 2))),
              )
            else ...[
            const SizedBox(height: 16),
            ...times.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.nameAr, style: TextStyle(fontSize: 16, color: colorScheme.onSurface)),
                      Text(TimeFormat.formatTime(context, e.hour, e.minute).toLocaleDigits(locale), style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
                    ],
                  ),
                )),
            if (onFullMonthTap != null) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: onFullMonthTap,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kShapeRadius),
                  ),
                ),
                child: Text(
                  l10n.fullMonth,
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
            ],
          ],
        ),
      ),
    );
  }
}

class _MasterTreasuryCard extends HookWidget {
  const _MasterTreasuryCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final totalStream = useMemoized(LuminousService.watchTotal);
    final snapshot = useStream(totalStream);
    final total = snapshot.data ?? 0;
    return AppCard(
      icon: Icons.savings_rounded,
      title: l10n.masterTreasury,
      value: total.toString().toLocaleDigits(Localizations.localeOf(context)),
    );
  }
}

class _TodaysDhikrProgressBar extends HookWidget {
  const _TodaysDhikrProgressBar({required this.l10n, required this.isar});

  final AppLocalizations l10n;
  final Isar isar;

  @override
  Widget build(BuildContext context) {
    final summaryFuture = useMemoized(() => getTodayDhikrSummary(isar));
    final snapshot = useFuture(summaryFuture);
    final completed = snapshot.hasData ? snapshot.data!.completed : 0;
    final total = snapshot.hasData ? snapshot.data!.total : 5;
    final progress = total > 0 ? completed / total : 0.0;
    return AppCard(
      progressTitle: l10n.todaysDhikr,
      progressLabel: '${completed.toString().toLocaleDigits(Localizations.localeOf(context))} / $total',
      progress: progress,
    );
  }
}

class _QuickAccessRow extends StatelessWidget {
  const _QuickAccessRow({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.quickAccess,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.95),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _QuickAccessChip(
              icon: Icons.menu_book_rounded,
              label: l10n.quran,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MushafScreen()),
              ),
            ),
            _QuickAccessChip(
              icon: Icons.favorite_rounded,
              label: l10n.adhkar,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const DhikrScreen()),
              ),
            ),
            _QuickAccessChip(
              icon: Icons.explore_rounded,
              label: l10n.qibla,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const QiblaScreen()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickAccessChip extends StatelessWidget {
  const _QuickAccessChip({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(kShapeRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(kShapeRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: colorScheme.onSurface, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.95),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
