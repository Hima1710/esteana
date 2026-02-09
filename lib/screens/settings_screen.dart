import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_mode_provider.dart';
import '../generated/l10n/app_localizations.dart';

/// شاشة الإعدادات: اللغة، المظهر (نظام / فاتح / داكن)، وحول التطبيق.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const String appVersion = '1.0.0';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradient = AppGradients.gradientFor(theme.brightness);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionTitle(title: l10n.language),
              const SizedBox(height: 8),
              _LanguageTile(l10n: l10n),
              const SizedBox(height: 24),
              _SectionTitle(title: l10n.theme),
              const SizedBox(height: 8),
              _ThemeModeTile(l10n: l10n),
              const SizedBox(height: 24),
              _SectionTitle(title: l10n.about),
              const SizedBox(height: 8),
              _AboutTile(l10n: l10n, colorScheme: colorScheme),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: colorScheme.primary,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    final isArabic = locale?.languageCode == 'ar';
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius)),
      child: ListTile(
        leading: Icon(Icons.language_rounded, color: colorScheme.primary),
        title: Text(l10n.language),
        trailing: FilledButton.tonal(
          onPressed: () => context.read<LocaleProvider>().toggleLocale(),
          child: Text(isArabic ? 'العربية' : 'English'),
        ),
      ),
    );
  }
}

class _ThemeModeTile extends StatelessWidget {
  const _ThemeModeTile({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<ThemeModeProvider>().themeMode;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.palette_outlined, color: colorScheme.primary),
                const SizedBox(width: 16),
                Text(
                  l10n.theme,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(value: ThemeMode.system, label: Text(l10n.themeSystem), icon: const Icon(Icons.brightness_auto_rounded, size: 18)),
                ButtonSegment(value: ThemeMode.light, label: Text(l10n.themeLight), icon: const Icon(Icons.light_mode_rounded, size: 18)),
                ButtonSegment(value: ThemeMode.dark, label: Text(l10n.themeDark), icon: const Icon(Icons.dark_mode_rounded, size: 18)),
              ],
              selected: {mode},
              onSelectionChanged: (Set<ThemeMode> selected) {
                context.read<ThemeModeProvider>().setThemeMode(selected.first);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutTile extends StatelessWidget {
  const _AboutTile({required this.l10n, required this.colorScheme});

  final AppLocalizations l10n;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius)),
      child: ListTile(
        leading: Icon(Icons.info_outline_rounded, color: colorScheme.primary),
        title: Text(l10n.about),
        subtitle: Text('${l10n.appTitle} · ${l10n.version} ${SettingsScreen.appVersion}'),
      ),
    );
  }
}
