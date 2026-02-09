import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../hooks/use_l10n.dart';
import '../../hooks/use_isar.dart';
import '../../models/mushaf_surah.dart';
import '../../services/mushaf_api_service.dart';
import 'mushaf_index_screen.dart';

/// نقطة الدخول لوحدة المصحف — تحميل وبذر السور من API ثم عرض الفهرس.
class MushafScreen extends HookWidget {
  const MushafScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = useL10n();
    final isar = useIsar();
    final loading = useState(true);
    final error = useState(false);

    useEffect(() {
      void init() async {
        final count = await isar.mushafSurahs.count();
        if (count == 0) {
          final ok = await fetchAndSeedMushafSurahs(isar);
          if (!ok) error.value = true;
        }
        loading.value = false;
      }
      init();
      return null;
    }, [isar]);

    if (loading.value) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.quran)),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(l10n.mushafLoading),
            ],
          ),
        ),
      );
    }

    if (error.value) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.quran)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.noResults, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.cancel),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const MushafIndexScreen();
  }
}
