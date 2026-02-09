import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/app_theme.dart';
import '../../hooks/use_l10n.dart';
import '../../hooks/use_isar.dart';
import '../../services/mushaf_api_service.dart';
import '../../services/progress_system.dart';
import '../../widgets/luminous_effect.dart';
import '../../models/mushaf_page_progress.dart';

const String _kMushafUsePageImagesKey = 'mushaf_use_page_images';

/// واجهة القراءة الغامرة — PageView مع تدرج Teal وحواف 24dp، وربط إكمال الصفحة بـ LuminousEffect و ProgressSystem.
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
    final usePageImages = useState<bool>(false);

    useEffect(() {
      void loadCompleted() async {
        final list = await isar.mushafPageProgress.where().findAll();
        completedPages.value = list.map((e) => e.pageNumber).toSet();
      }
      loadCompleted();
      return null;
    }, [isar]);

    useEffect(() {
      SharedPreferences.getInstance().then((prefs) {
        usePageImages.value = prefs.getBool(_kMushafUsePageImagesKey) ?? false;
      });
      return null;
    }, []);

    Future<void> togglePageImages() async {
      usePageImages.value = !usePageImages.value;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kMushafUsePageImagesKey, usePageImages.value);
    }

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

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.gradientFor(Theme.of(context).brightness),
        ),
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
                    IconButton(
                      icon: Icon(usePageImages.value ? Icons.text_fields_rounded : Icons.image_rounded),
                      tooltip: usePageImages.value ? l10n.mushafViewText : l10n.mushafViewImages,
                      onPressed: togglePageImages,
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
                    currentPage.value = page;
                    onPageCompleted(page);
                  },
                  itemBuilder: (context, index) {
                    final pageNumber = index + 1;
                    return _MushafPageView(
                      pageNumber: pageNumber,
                      usePageImages: usePageImages.value,
                      doneLabel: l10n.done,
                      onMarkComplete: () => onPageCompleted(pageNumber),
                      isCompleted: completedPages.value.contains(pageNumber),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MushafPageView extends HookWidget {
  const _MushafPageView({
    required this.pageNumber,
    required this.usePageImages,
    required this.doneLabel,
    required this.onMarkComplete,
    required this.isCompleted,
  });

  final int pageNumber;
  final bool usePageImages;
  final String doneLabel;
  final VoidCallback onMarkComplete;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final verses = useState<List<Map<String, dynamic>>>([]);
    final loading = useState(true);
    final imageError = useState(false);

    useEffect(() {
      void load() async {
        final list = await fetchVersesByPage(pageNumber);
        verses.value = list;
        loading.value = false;
      }
      loading.value = true;
      imageError.value = false;
      load();
      return null;
    }, [pageNumber, usePageImages]);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget _buildTextView() {
      if (loading.value) {
        return Center(child: CircularProgressIndicator(color: colorScheme.primary));
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 2.2,
                fontSize: 22,
                color: colorScheme.onSurface,
              ),
              children: verses.value
                  .map<InlineSpan>((v) {
                    final text = v['text_uthmani'] as String? ?? '';
                    return TextSpan(text: '$text ');
                  })
                  .toList(),
            ),
          ),
        ),
      );
    }

    Widget pageContent;
    if (usePageImages) {
      final url = mushafPageImageUrl(pageNumber);
      if (url.isEmpty) {
        pageContent = _buildTextView();
      } else {
        pageContent = Image.network(
          url,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(child: CircularProgressIndicator(color: colorScheme.primary));
          },
          errorBuilder: (context, error, stackTrace) {
            imageError.value = true;
            return _buildTextView();
          },
        );
      }
    } else {
      pageContent = _buildTextView();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kShapeRadius),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(kShapeRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: pageContent),
              if (!isCompleted)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: FilledButton.icon(
                    onPressed: onMarkComplete,
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: Text(doneLabel),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius)),
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Icon(Icons.check_circle_rounded, color: colorScheme.primary, size: 32),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
