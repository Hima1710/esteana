import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:isar/isar.dart';

import '../../hooks/use_l10n.dart';
import '../../hooks/use_isar.dart';
import '../../widgets/app_card.dart';
import '../../models/mushaf_surah.dart';
import 'mushaf_reader_screen.dart';

/// شاشة فهرس المصحف — قائمة السور باستخدام AppCard الموحد، مع دعم الترجمة.
class MushafIndexScreen extends HookWidget {
  const MushafIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = useL10n();
    final isar = useIsar();
    final surahs = useState<List<MushafSurah>>([]);
    final loading = useState(true);

    useEffect(() {
      void load() async {
        final list = await isar.mushafSurahs.where().sortBySurahNumber().findAll();
        surahs.value = list;
        loading.value = false;
      }
      load();
      return null;
    }, [isar]);

    if (loading.value) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.mushafIndex)),
        body: Center(child: Text(l10n.mushafLoading)),
      );
    }

    if (surahs.value.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.mushafIndex)),
        body: Center(child: Text(l10n.noResults)),
      );
    }

    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.mushafIndex)),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        cacheExtent: 400,
        itemCount: surahs.value.length,
        itemBuilder: (context, index) {
          final s = surahs.value[index];
          final revelationLabel = s.revelationPlace == 'madinah' ? l10n.madani : l10n.makki;
          return RepaintBoundary(
            key: ValueKey<int>(s.surahNumber),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                icon: Icons.menu_book_rounded,
                title: isAr ? s.nameAr : s.nameEn,
                subtitle: '$revelationLabel · ${l10n.versesCount(s.versesCount)}',
                value: '${s.startPage} – ${s.endPage}',
                useTealTint: true,
                onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => MushafReaderScreen(initialPage: s.startPage),
                  ),
                );
              },
              ),
            ),
          );
        },
      ),
    );
  }
}
