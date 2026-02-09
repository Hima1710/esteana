import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../generated/l10n/app_localizations.dart';
import '../services/prayer_times_service.dart';
import '../theme/app_theme.dart';
import '../utils/locale_digits.dart';
import '../utils/time_format.dart';

/// شاشة مواعيد الشهر بالكامل — هجري وميلادي، ضمن النظام الموحد (الثيم والكروت).
class PrayerMonthScreen extends StatefulWidget {
  const PrayerMonthScreen({super.key});

  @override
  State<PrayerMonthScreen> createState() => _PrayerMonthScreenState();
}

class _PrayerMonthScreenState extends State<PrayerMonthScreen> {
  Future<List<PrayerDayRow>>? _monthFuture;
  String? _error;
  bool _isArabic = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isArabic = Localizations.localeOf(context).languageCode == 'ar';
      _loadMonth();
    });
  }

  Future<void> _loadMonth() async {
    setState(() {
      _error = null;
      _monthFuture = _fetchMonth();
    });
  }

  Future<List<PrayerDayRow>> _fetchMonth() async {
    final now = DateTime.now();
    final position = await _getPosition();
    if (position == null) {
      setState(() => _error = 'location_required');
      return [];
    }
    return PrayerTimesService.fetchMonthCalendar(
      year: now.year,
      month: now.month,
      latitude: position.latitude,
      longitude: position.longitude,
      isArabic: _isArabic,
    );
  }

  Future<Position?> _getPosition() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return null;
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final requested = await Geolocator.requestPermission();
      if (requested != LocationPermission.whileInUse &&
          requested != LocationPermission.always) {
        return null;
      }
    }
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradient = AppGradients.gradientFor(theme.brightness);

    return Container(
      decoration: BoxDecoration(gradient: gradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(l10n.prayerTimesMonth),
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.onSurface,
          elevation: 0,
        ),
        body: _error != null
            ? _buildError(colorScheme, l10n)
            : _monthFuture == null
                ? const Center(
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : FutureBuilder<List<PrayerDayRow>>(
                    future: _monthFuture,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: SizedBox(
                            width: 36,
                            height: 36,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }
                      final days = snapshot.data!;
                      if (days.isEmpty) {
                        return Center(
                          child: Text(
                            l10n.noResults,
                            style: TextStyle(color: colorScheme.onSurface),
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        cacheExtent: 400,
                        itemCount: days.length,
                        itemBuilder: (context, index) {
                          return RepaintBoundary(
                            key: ValueKey(index),
                            child: _DayCard(
                              row: days[index],
                              colorScheme: colorScheme,
                              l10n: l10n,
                            ),
                          );
                        },
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildError(ColorScheme colorScheme, AppLocalizations l10n) {
    final message = _error == 'location_required'
        ? l10n.locationRequired
        : _error!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.error, fontSize: 16),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _loadMonth,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kShapeRadius),
                ),
              ),
              child: Text(l10n.submit),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  static final _shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius));

  const _DayCard({
    required this.row,
    required this.colorScheme,
    required this.l10n,
  });

  final PrayerDayRow row;
  final ColorScheme colorScheme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return Card.filled(
      margin: const EdgeInsets.only(bottom: 12),
      shape: _shape,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dateHijri,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        row.dateHijri.toLocaleDigits(locale),
                        style: TextStyle(
                          fontSize: 15,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dateGregorian,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        row.dateGregorian.toLocaleDigits(locale),
                        style: TextStyle(
                          fontSize: 15,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            ...row.times.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      e.nameAr,
                      style: TextStyle(
                        fontSize: 15,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      TimeFormat.formatTime(context, e.hour, e.minute).toLocaleDigits(locale),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
