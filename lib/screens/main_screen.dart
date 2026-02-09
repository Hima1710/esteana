import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../hooks/use_l10n.dart';
import '../providers/locale_provider.dart';
import '../widgets/luminous_floating_box.dart';
import 'settings_screen.dart';
import 'tabs/mihrab_tab.dart';
import 'tabs/athari_tab.dart';
import 'tabs/majlis_tab.dart';
import 'tabs/zad_tab.dart';

/// الشاشة الرئيسية — NavigationBar (Material 3) بأربع تابات + مبدّل اللغة.
class MainScreen extends HookWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);
    final l10n = useL10n();
    final locale = context.select<LocaleProvider, Locale?>((p) => p.locale);

    final tabs = [
      _TabInfo(title: l10n.mihrab, icon: Icons.mosque_rounded, body: const MihrabTab()),
      _TabInfo(title: l10n.athari, icon: Icons.check_circle_outline_rounded, body: const AthariTab()),
      _TabInfo(title: l10n.majlis, icon: Icons.groups_rounded, body: const MajlisTab()),
      _TabInfo(title: l10n.zad, icon: Icons.play_circle_outline_rounded, body: const ZadTab()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(tabs[currentIndex.value].title),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            tooltip: l10n.settings,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.language_rounded),
            tooltip: locale?.languageCode == 'ar' ? 'English' : 'العربية',
            onPressed: () => context.read<LocaleProvider>().toggleLocale(),
          ),
        ],
      ),
      body: Stack(
        children: [
          IndexedStack(
            index: currentIndex.value,
            children: tabs.map((t) => t.body).toList(),
          ),
          RepaintBoundary(child: const LuminousFloatingBox()),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex.value,
        onDestinationSelected: (i) => currentIndex.value = i,
        destinations: tabs
            .map((t) => NavigationDestination(
                  icon: Icon(t.icon),
                  label: t.title,
                ))
            .toList(),
      ),
    );
  }
}

class _TabInfo {
  const _TabInfo({required this.title, required this.icon, required this.body});
  final String title;
  final IconData icon;
  final Widget body;
}
