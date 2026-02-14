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
import 'package:confetti/confetti.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/prayer_times_service.dart';
import '../../services/prayer_countdown_widget_service.dart';
import '../../services/occasion_service.dart';
import '../../services/hijri_offset_service.dart';
import '../../models/occasion.dart';
import '../../services/dhikr_progress_service.dart' show getTodayDhikrSummary;
import '../../services/luminous_service.dart';
import '../../widgets/app_card.dart';
import '../../widgets/tasbih_bottom_sheet.dart';
import '../../generated/l10n/app_localizations.dart';
import '../dhikr_screen.dart';
import '../mushaf/mushaf_screen.dart';
import '../qibla_screen.dart';
import '../prayer_month_screen.dart';

/// ألوان وتدرج الذهب اللامع (لمسة ذهبية).
const Color _kGoldLight = Color(0xFFFFD700);
const Color _kGoldMid = Color(0xFFFDB931);
const Color _kGoldDark = Color(0xFF8A6E2F);
const LinearGradient _kGoldenGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [_kGoldLight, _kGoldMid, _kGoldDark],
);
const List<BoxShadow> _kGoldenGlow = [
  BoxShadow(
    color: Color(0x40FFD700),
    blurRadius: 16,
    spreadRadius: 0,
  ),
  BoxShadow(
    color: Color(0x20FDB931),
    blurRadius: 24,
    spreadRadius: -2,
  ),
];

/// التابة الأولى — المحراب: العد التنازلي، مواعيد أفقية، وصول سريع، كروت جنباً إلى جنب.
class MihrabTab extends HookWidget {
  const MihrabTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = useL10n();
    final isar = useIsar();
    final gradient = AppGradients.gradientFor(Theme.of(context).brightness);
    final timesFuture = useMemoized(() => PrayerTimesService.fetchTodayTimes(), []);
    useListenable(HijriOffsetService.offsetNotifier);

    final padding = MediaQuery.viewPaddingOf(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(gradient: gradient),
      child: FutureBuilder<List<PrayerTimeEntry>>(
        future: timesFuture,
        builder: (context, snapshot) {
          final times = snapshot.data ?? PrayerTimesService.defaultTimes;
          final loading = !snapshot.hasData && snapshot.connectionState == ConnectionState.waiting;
          return Stack(
            children: [
              CustomScrollView(
                cacheExtent: 400,
                slivers: [
                  SliverPadding(padding: EdgeInsets.only(top: padding.top)),
                  SliverToBoxAdapter(
                    child: RepaintBoundary(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _NextPrayerCountdown(
                              timeRemainingLabel: l10n.timeRemaining,
                              times: times,
                              isLoading: loading,
                            ),
                            const SizedBox(height: 16),
                            _QuickAccessRow(l10n: l10n),
                            const SizedBox(height: 16),
                            _PrayerTimesHorizontal(
                              times: times,
                              isLoading: loading,
                              onFullMonthTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const PrayerMonthScreen(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _MasterTreasuryCard(l10n: l10n)),
                                const SizedBox(width: 12),
                                Expanded(child: _TodaysDhikrProgressBar(l10n: l10n, isar: isar)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                SliverPadding(padding: EdgeInsets.only(bottom: padding.bottom + 100)),
              ],
            ),
            Positioned(
              top: padding.top + 4,
              right: 12,
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: const Icon(Icons.calendar_month_rounded),
                  onPressed: () => _showOccasionsBottomSheet(context),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh.withValues(alpha: 0.9),
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            const Positioned.fill(child: _OccasionConfettiOverlay()),
            ],
          );
        },
      ),
    );
  }
}

const String _kConfettiShownPrefix = 'confetti_shown_';

/// طبقة كونفيتي تُشغّل مرة واحدة في اليوم عند كون اليوم أول أيام المناسبة (المستخدم داخل التطبيق).
class _OccasionConfettiOverlay extends HookWidget {
  const _OccasionConfettiOverlay();

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(
      () => ConfettiController(duration: const Duration(seconds: 4)),
      [],
    );
    useEffect(() {
      return controller.dispose;
    }, [controller]);

    final size = MediaQuery.sizeOf(context);
    final effectiveToday = HijriOffsetService.effectiveToday;
    final dateKey =
        '${effectiveToday.year}_${effectiveToday.month}_${effectiveToday.day}';

    useEffect(() {
      void checkAndPlay() async {
        final nearest = OccasionService.getNearestOccasionWithCountdown();
        if (nearest == null) return;
        if (!OccasionService.isFirstDayOfOccasion(nearest.$1)) return;
        final prefs = await SharedPreferences.getInstance();
        final key = '$_kConfettiShownPrefix${nearest.$1.id}_$dateKey';
        if (prefs.getBool(key) == true) return;
        controller.play();
        await prefs.setBool(key, true);
      }

      checkAndPlay();
      return null;
    }, [controller, dateKey]);

    return IgnorePointer(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConfettiWidget(
          confettiController: controller,
          canvas: size,
          numberOfParticles: 18,
          blastDirectionality: BlastDirectionality.explosive,
          gravity: 0.15,
          emissionFrequency: 0.03,
          colors: const [
            Color(0xFFFFD700),
            Color(0xFFFDB931),
            Color(0xFF8A6E2F),
            Color(0xFF4A90A4),
            Color(0xFF2E7D32),
          ],
        ),
      ),
    );
  }
}

void _showOccasionsBottomSheet(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final locale = Localizations.localeOf(context).languageCode;
  final today = HijriOffsetService.effectiveToday;
  final todayStart = DateTime(today.year, today.month, today.day);

  final occasions = OccasionService.getAllOccasions()
    ..sort((a, b) {
      final dtA = a.$2;
      final dtB = b.$2;
      final startA = DateTime(dtA.year, dtA.month, dtA.day);
      final startB = DateTime(dtB.year, dtB.month, dtB.day);
      final diffA = startA.difference(todayStart).inDays;
      final diffB = startB.difference(todayStart).inDays;
      final groupA = diffA == 0 ? 0 : (diffA > 0 ? 1 : 2);
      final groupB = diffB == 0 ? 0 : (diffB > 0 ? 1 : 2);
      if (groupA != groupB) return groupA.compareTo(groupB);
      if (diffA >= 0) return diffA.compareTo(diffB);
      return (-diffA).compareTo(-diffB);
    });

  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Container(
      height: MediaQuery.of(ctx).size.height * 0.5,
      decoration: BoxDecoration(
        color: Theme.of(ctx).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Text(
            l10n.occasionsTitle,
            style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: 'Noto Naskh Arabic',
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: occasions.length,
              itemBuilder: (_, i) {
                final o = occasions[i].$1;
                final dt = occasions[i].$2;
                final dateStr = '${dt.day}/${dt.month}/${dt.year}';
                final occasionStart = DateTime(dt.year, dt.month, dt.day);
                final daysDiff = occasionStart.difference(todayStart).inDays;
                final daysText = daysDiff == 0
                    ? l10n.todayIsOccasion
                    : (daysDiff > 0
                        ? l10n.daysUntilOccasion(daysDiff)
                        : l10n.daysSinceOccasion(-daysDiff));
                return ListTile(
                  leading: Icon(_iconForOccasion(o.iconType), color: _kGoldMid),
                  title: Text(
                    o.name(locale),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Noto Naskh Arabic',
                    ),
                  ),
                  subtitle: Text(
                    daysText,
                    style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                      color: Theme.of(ctx).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Noto Naskh Arabic',
                    ),
                  ),
                  trailing: Text(
                    dateStr,
                    style: Theme.of(ctx).textTheme.bodySmall,
                    textAlign: TextAlign.end,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

IconData _iconForOccasion(OccasionIconType type) {
  switch (type) {
    case OccasionIconType.crescent:
      return Icons.nightlight_round;
    case OccasionIconType.kaaba:
      return Icons.account_balance_rounded;
    case OccasionIconType.book:
      return Icons.menu_book_rounded;
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

    final effectiveToday = HijriOffsetService.effectiveToday;
    final nearestOccasion = OccasionService.getNearestOccasionWithCountdown();
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final localeStr = locale.toString();
    final occasionName = nearestOccasion?.$1.name(localeStr);
    final occasionDaysText = nearestOccasion == null
        ? null
        : (nearestOccasion.$3 == 0
            ? l10n.todayIsOccasion
            : l10n.daysUntilOccasion(nearestOccasion.$3));

    if (!isLoading && next != null) {
      final shouldUpdate = lastWidgetUpdate.value == null ||
          DateTime.now().difference(lastWidgetUpdate.value!).inSeconds >= 60;
      if (shouldUpdate) {
        lastWidgetUpdate.value = DateTime.now();
        final dateGregorian = LocaleDigits.format(_formatGregorian(now60.value, localeStr), locale);
        final dateHijri = LocaleDigits.format(_formatHijri(effectiveToday, localeStr), locale);
        updatePrayerCountdownWidget(
          labelNext: l10n.nextPrayer,
          dateGregorianLine: '${l10n.dateGregorian}: $dateGregorian',
          dateHijriLine: '${l10n.dateHijri}: $dateHijri',
          labelRemaining: timeRemainingLabel,
          today: now60.value,
          times: times,
          occasionName: occasionName,
          occasionDays: occasionDaysText,
        );
      }
    }

    return _NextPrayerHeader(
      nextNameAr: next?.nameAr,
      nextAt: next?.at,
      today: now60.value,
      hijriDisplayDate: effectiveToday,
      isLoading: isLoading,
      timeRemainingLabel: timeRemainingLabel,
      occasionName: occasionName,
      occasionDaysText: occasionDaysText,
      onTap: () => _showOccasionsBottomSheet(context),
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
    DateTime? hijriDisplayDate,
    required this.timeRemainingLabel,
    this.occasionName,
    this.occasionDaysText,
    this.onTap,
    required this.countdownChild,
    this.isLoading = false,
  }) : hijriDisplayDate = hijriDisplayDate ?? today;

  final String? nextNameAr;
  final DateTime? nextAt;
  final DateTime today;
  final DateTime hijriDisplayDate;
  final String timeRemainingLabel;
  final String? occasionName;
  final String? occasionDaysText;
  final VoidCallback? onTap;
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
    final dateHijri = LocaleDigits.format(_formatHijri(hijriDisplayDate, localeStr), locale);
    final nextLabel = isLoading
        ? '...'
        : (nextNameAr != null && nextAt != null
            ? '$nextNameAr — ${TimeFormat.formatTime(context, nextAt!.hour, nextAt!.minute).toLocaleDigits(locale)}'
            : '--');

    final showOccasion = occasionName != null && occasionDaysText != null;
    final occasionLine = showOccasion ? '$occasionDaysText • $occasionName' : null;

    Widget card = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerHigh : null,
        gradient: isDark ? null : _kGoldenGradient,
        borderRadius: BorderRadius.circular(kShapeRadius),
        boxShadow: [
          ..._kGoldenGlow,
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
                  if (occasionLine != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      occasionLine,
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Noto Naskh Arabic',
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          countdownChild,
        ],
      ),
    );

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(kShapeRadius),
          child: card,
        ),
      );
    }
    return card;
  }
}

/// مواعيد الصلاة في تمرير أفقي؛ الصلاة القادمة مميزة بحجم أكبر وإطار ذهبي.
class _PrayerTimesHorizontal extends HookWidget {
  const _PrayerTimesHorizontal({
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
    final now = useState(DateTime.now());
    useEffect(() {
      final t = Timer.periodic(const Duration(seconds: 60), (_) => now.value = DateTime.now());
      return t.cancel;
    }, []);
    final nextNameAr = PrayerTimesService.getNextPrayer(now.value, times)?.nameAr;

    if (isLoading) {
      return SizedBox(
        height: 72,
        child: Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 2, color: _kGoldMid),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.prayerTimes,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface.withValues(alpha: 0.95),
              ),
            ),
            if (onFullMonthTap != null)
              TextButton(
                onPressed: onFullMonthTap,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  l10n.fullMonth,
                  style: TextStyle(
                    color: _kGoldMid,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 78,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: times.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final e = times[index];
              final isNext = e.nameAr == nextNameAr;
              return _PrayerTimeChip(
                nameAr: e.nameAr,
                timeStr: TimeFormat.formatTime(context, e.hour, e.minute).toLocaleDigits(locale),
                isNext: isNext,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PrayerTimeChip extends StatelessWidget {
  const _PrayerTimeChip({
    required this.nameAr,
    required this.timeStr,
    this.isNext = false,
  });

  final String nameAr;
  final String timeStr;
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isNext ? 18 : 14,
        vertical: isNext ? 14 : 10,
      ),
      decoration: BoxDecoration(
        gradient: isNext ? _kGoldenGradient : null,
        color: isNext ? null : colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: isNext ? Border.all(color: _kGoldLight, width: 1.5) : null,
        boxShadow: isNext ? _kGoldenGlow : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            nameAr,
            style: TextStyle(
              fontSize: isNext ? 15 : 13,
              fontWeight: isNext ? FontWeight.bold : FontWeight.w600,
              color: isNext ? Colors.white : colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            timeStr,
            style: TextStyle(
              fontSize: isNext ? 14 : 12,
              fontWeight: FontWeight.w600,
              color: isNext ? Colors.white.withValues(alpha: 0.95) : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
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
      icon: Icons.workspace_premium_rounded,
      iconColor: const Color(0xFFD4AF37), // ذهبي لصندوق الكنز
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.95),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _QuickAccessChip(
                icon: Icons.menu_book_rounded,
                label: l10n.quran,
                useGoldenGlow: true,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MushafScreen()),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickAccessChip(
                icon: Icons.favorite_rounded,
                label: l10n.adhkar,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const DhikrScreen()),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickAccessChip(
                icon: Icons.explore_rounded,
                label: l10n.qibla,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const QiblaScreen()),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickAccessChip(
                icon: Icons.lens_rounded,
                label: l10n.tasbih,
                onTap: () => showTasbihBottomSheet(context),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickAccessChip extends StatelessWidget {
  const _QuickAccessChip({
    required this.icon,
    required this.label,
    this.onTap,
    this.useGoldenGlow = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool useGoldenGlow;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final useGradient = useGoldenGlow;
    return Material(
      borderRadius: BorderRadius.circular(kShapeRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(kShapeRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            gradient: useGradient ? _kGoldenGradient : null,
            color: useGradient ? null : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(kShapeRadius),
            boxShadow: useGoldenGlow ? _kGoldenGlow : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: useGradient ? Colors.white : colorScheme.onSurface,
                size: useGradient ? 36 : 30,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: useGradient ? Colors.white : colorScheme.onSurface.withValues(alpha: 0.95),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
