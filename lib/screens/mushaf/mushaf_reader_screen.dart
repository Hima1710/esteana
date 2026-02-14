import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:isar/isar.dart';

import '../../theme/app_theme.dart';
import '../../hooks/use_l10n.dart';
import '../../hooks/use_isar.dart';
import '../../services/mushaf_api_service.dart';
import '../../services/mushaf_storage_service.dart';
import '../../services/progress_system.dart';
import '../../widgets/luminous_effect.dart';
import '../../widgets/mushaf_page.dart';
import '../../widgets/mushaf_surah_drawer.dart';
import '../../models/mushaf_page_progress.dart';
import '../../models/mushaf_surah.dart';

/// نسبة عرض صفحة المصحف إلى ارتفاعها (قريبة من A4 عمودي) — تثبيت المساحة يمنع القفزة عند تحميل الصورة.
const double _kMushafPageAspectRatio = 0.707;

/// واجهة القراءة الغامرة — PageView مع صور مصحف المدينة V4 وربط إكمال الصفحة بـ LuminousEffect و ProgressSystem.
class MushafReaderScreen extends HookWidget {
  const MushafReaderScreen({super.key, this.initialPage = 1});

  final int initialPage;

  @override
  Widget build(BuildContext context) {
    final l10n = useL10n();
    final isar = useIsar();
    final pageController = usePageController(initialPage: (initialPage - 1).clamp(0, kMushafTotalPages - 1));
    final currentPage = useState<int>(initialPage.clamp(1, kMushafTotalPages));
    final completedPages = useState<Set<int>>({});
    final surahs = useState<List<MushafSurah>>([]);

    useEffect(() {
      if (kDebugMode) debugPrint('[Mushaf] فتح قارئ المصحف — الصفحة الابتدائية: $initialPage');
      void loadCompleted() async {
        final list = await isar.mushafPageProgress.where().findAll();
        completedPages.value = list.map((e) => e.pageNumber).toSet();
      }
      loadCompleted();
      return null;
    }, [isar]);

    useEffect(() {
      void loadSurahs() async {
        final list = await isar.mushafSurahs.where().sortBySurahNumber().findAll();
        surahs.value = list;
      }
      loadSurahs();
      return null;
    }, [isar]);

    void onPageCompleted(int pageNumber) {
      if (completedPages.value.contains(pageNumber)) return;
      completedPages.value = {...completedPages.value, pageNumber};
      LuminousEffect.trigger(context);
      ProgressSystem.recordCompletion(
        isar: isar,
        luminousCount: 1,
        goodDeedTitle: l10n.quran,
        externalId: 'mushaf_page_$pageNumber',
      );
      isar.writeTxn(() async {
        await isar.mushafPageProgress.put(MushafPageProgress.forPage(pageNumber));
      });
    }

    void goToPage(int pageNumber) {
      final p = pageNumber.clamp(1, kMushafTotalPages);
      if (kDebugMode) debugPrint('[Mushaf] الفهرس: طلب الانتقال إلى صفحة $p');
      currentPage.value = p;
      final index = (p - 1).clamp(0, kMushafTotalPages - 1);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (pageController.hasClients) {
          if (kDebugMode) debugPrint('[Mushaf] الفهرس: تنفيذ animateToPage(index: $index)');
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
          );
        }
      });
    }

    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return FutureBuilder<void>(
      future: MushafStorageService.ensureInit(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppColors.mushafPaper,
            body: Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)),
          );
        }
        return Scaffold(
          backgroundColor: AppColors.mushafPaper,
          extendBody: true,
          extendBodyBehindAppBar: true,
          endDrawer: surahs.value.isEmpty
              ? null
              : MushafSurahDrawer(
                  surahs: surahs.value,
                  isArabic: isAr,
                  searchHint: l10n.searchSurahOrVerse,
                  onSurahSelected: goToPage,
                ),
          body: Container(
            color: AppColors.mushafPaper,
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Text(
                          l10n.pageOf(currentPage.value, kMushafTotalPages),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        surahs.value.isEmpty
                            ? const SizedBox(width: 48)
                            : IconButton(
                                icon: const Icon(Icons.menu_rounded),
                                onPressed: () => Scaffold.of(context).openEndDrawer(),
                              ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: kMushafTotalPages,
                      onPageChanged: (index) {
                        final page = index + 1;
                        if (kDebugMode) debugPrint('[Mushaf] تقليب: انتقل إلى صفحة $page (index $index)');
                        currentPage.value = page;
                        onPageCompleted(page);
                      },
                      itemBuilder: (context, index) {
                        final pageNumber = index + 1;
                        if (kDebugMode && pageNumber <= 3) debugPrint('[Mushaf] itemBuilder: بناء ويدجت صفحة $pageNumber');
                        return _MushafPageView(
                          pageNumber: pageNumber,
                          doneLabel: l10n.done,
                          onMarkComplete: () => onPageCompleted(pageNumber),
                          isCompleted: completedPages.value.contains(pageNumber),
                          localFilePath: MushafStorageService.getLocalPathForPage(pageNumber),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MushafPageView extends StatelessWidget {
  const _MushafPageView({
    required this.pageNumber,
    required this.doneLabel,
    required this.onMarkComplete,
    required this.isCompleted,
    this.localFilePath,
  });

  final int pageNumber;
  final String doneLabel;
  final VoidCallback onMarkComplete;
  final bool isCompleted;
  final String? localFilePath;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kShapeRadius),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.mushafPaper,
            borderRadius: BorderRadius.circular(kShapeRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: _kMushafPageAspectRatio,
                    child: MushafPage(pageNumber: pageNumber, fit: BoxFit.contain, localFilePath: localFilePath),
                  ),
                ),
              ),
              SizedBox(
                height: 56,
                child: Center(
                  child: !isCompleted
                      ? FilledButton.icon(
                          onPressed: onMarkComplete,
                          icon: const Icon(Icons.check_circle_outline_rounded),
                          label: Text(doneLabel),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius)),
                          ),
                        )
                      : Icon(Icons.check_circle_rounded, color: colorScheme.primary, size: 32),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
