import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';
import '../hooks/use_l10n.dart';
import '../data/adhkar_data.dart';
import 'dhikr_category_screen.dart';

/// شاشة الأذكار — 5 فئات (حصن المسلم)، تدرج teal، Card.filled 24dp، HookWidget.
class DhikrScreen extends HookWidget {
  const DhikrScreen({super.key});

  static const List<({String id, IconData icon})> _categoryIcons = [
    (id: 'morning', icon: Icons.wb_sunny_rounded),
    (id: 'evening', icon: Icons.nightlight_round),
    (id: 'afterPrayer', icon: Icons.mosque_rounded),
    (id: 'sleep', icon: Icons.bedtime_rounded),
    (id: 'tawba', icon: Icons.volunteer_activism_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = useL10n();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradient = AppGradients.gradientFor(theme.brightness);
    final adhkarFuture = useMemoized(loadAdhkarFromAssets);
    final snapshot = useFuture(adhkarFuture);

    String categoryTitle(String id) {
      switch (id) {
        case 'morning': return l10n.dhikrCategoryMorning;
        case 'evening': return l10n.dhikrCategoryEvening;
        case 'afterPrayer': return l10n.dhikrCategoryAfterPrayer;
        case 'sleep': return l10n.dhikrCategorySleep;
        case 'tawba': return l10n.dhikrCategoryTawba;
        default: return id;
      }
    }

    String categoryDesc(String id) {
      switch (id) {
        case 'morning': return l10n.dhikrDescMorning;
        case 'evening': return l10n.dhikrDescEvening;
        case 'afterPrayer': return l10n.dhikrDescAfterPrayer;
        case 'sleep': return l10n.dhikrDescSleep;
        case 'tawba': return l10n.dhikrDescTawba;
        default: return '';
      }
    }

    IconData iconFor(String id) {
      return _categoryIcons.firstWhere(
        (e) => e.id == id,
        orElse: () => (id: id, icon: Icons.menu_book_rounded),
      ).icon;
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.adhkar)),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          child:             snapshot.hasData
              ? ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  cacheExtent: 400,
                  itemCount: snapshot.data!.categories.length,
                  itemBuilder: (context, index) {
                    final cat = snapshot.data!.categories[index];
                    return RepaintBoundary(
                      key: ValueKey(cat.id),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card.filled(
                        key: ValueKey(cat.id),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kShapeRadius),
                        ),
                        child: InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => DhikrCategoryScreen(
                                  category: cat,
                                  categoryTitle: categoryTitle(cat.id),
                                  isTawba: cat.isTawba,
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(kShapeRadius),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(kShapeRadius),
                                  ),
                                  child: Icon(
                                    iconFor(cat.id),
                                    size: 28,
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        categoryTitle(cat.id),
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        categoryDesc(cat.id),
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onSurface.withValues(alpha: 0.8),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_left_rounded, color: colorScheme.onSurface),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                  },
                )
              : snapshot.hasError
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          '${snapshot.error}',
                          style: TextStyle(color: colorScheme.error),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(color: colorScheme.primary),
                    ),
        ),
      ),
    );
  }
}
