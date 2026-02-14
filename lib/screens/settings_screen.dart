import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_theme.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_mode_provider.dart';
import '../providers/auth_provider.dart';
import '../generated/l10n/app_localizations.dart';
import '../services/mushaf_api_service.dart';
import '../services/mushaf_storage_service.dart';
import '../services/hijri_offset_service.dart';
import 'privacy_policy_screen.dart';

/// شاشة الإعدادات: البروفايل، اللغة، المظهر، وحول التطبيق.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradient = AppGradients.gradientFor(theme.brightness);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
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
              _ProfileSection(colorScheme: colorScheme),
              const SizedBox(height: 24),
              _SectionTitle(title: l10n.language),
              const SizedBox(height: 8),
              _LanguageTile(l10n: l10n),
              const SizedBox(height: 24),
              _SectionTitle(title: l10n.theme),
              const SizedBox(height: 8),
              _ThemeModeTile(l10n: l10n),
              const SizedBox(height: 24),
              _SectionTitle(title: l10n.hijriDateAdjustment),
              const SizedBox(height: 8),
              _HijriAdjustmentTile(l10n: l10n),
              const SizedBox(height: 24),
              _SectionTitle(title: l10n.mushafOffline),
              const SizedBox(height: 8),
              _DownloadMushafTile(l10n: l10n),
              const SizedBox(height: 24),
              _SectionTitle(title: l10n.about),
              const SizedBox(height: 8),
              _PrivacyPolicyTile(l10n: l10n),
              const SizedBox(height: 8),
              _VersionTile(l10n: l10n, colorScheme: colorScheme),
              const SizedBox(height: 8),
              _AboutTile(l10n: l10n, colorScheme: colorScheme),
            ],
          ),
        ),
      ),
    );
  }
}

/// قسم البروفايل: صورة دائرية + بطاقة للزائر أو بيانات المسجّل.
class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = Supabase.instance.client.auth.currentUser;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _ProfileAvatar(isSignedIn: auth.isSignedIn, user: user),
            const SizedBox(width: 16),
            Expanded(
              child: auth.isSignedIn && user != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _displayName(user),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                        ),
                        if (user.email != null && user.email!.isNotEmpty)
                          Text(
                            user.email!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                                ),
                          ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
        if (!auth.isSignedIn) ...[
          const SizedBox(height: 12),
          _GuestCard(colorScheme: colorScheme),
        ],
        if (auth.isSignedIn || auth.isAnonymous) ...[
          const SizedBox(height: 12),
          _SignOutTile(colorScheme: colorScheme),
        ],
      ],
    );
  }

  static String _displayName(User? user) {
    if (user == null) return '';
    final meta = user.userMetadata;
    if (meta != null) {
      if (meta['full_name'] != null) return meta['full_name'] as String;
      if (meta['name'] != null) return meta['name'] as String;
    }
    if (user.email != null && user.email!.isNotEmpty) return user.email!;
    return 'مستخدم';
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.isSignedIn, this.user});

  final bool isSignedIn;
  final User? user;

  @override
  Widget build(BuildContext context) {
    const double size = 64;
    final colorScheme = Theme.of(context).colorScheme;

    if (isSignedIn && user != null) {
      final meta = user!.userMetadata;
      String? avatarUrl;
      if (meta != null && meta['avatar_url'] != null) {
        avatarUrl = meta['avatar_url'] as String?;
      }
      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: Image.network(
            avatarUrl,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _placeholderAvatar(context, size, colorScheme),
          ),
        );
      }
    }
    return _placeholderAvatar(context, size, colorScheme);
  }

  static Widget _placeholderAvatar(BuildContext context, double size, ColorScheme colorScheme) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person_rounded,
        size: size * 0.5,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}

/// بطاقة للزائر: دعوة لتسجيل الدخول بجوجل مع زر الربط/الدخول.
class _GuestCard extends StatelessWidget {
  const _GuestCard({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final isAnonymous = auth.isAnonymous;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'حساب غير مسجل — سجّل دخولك بجوجل لحفظ وردك وتظليل المصحف',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _onSignInPressed(context, auth, isAnonymous),
                icon: const Icon(Icons.g_mobiledata_rounded, size: 22),
                label: Text(isAnonymous ? 'ربط الحساب بجوجل' : 'تسجيل الدخول بجوجل'),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _onSignInPressed(BuildContext context, AuthProvider auth, bool isAnonymous) async {
    final (ok, errorMessage) = isAnonymous
        ? await auth.linkWithGoogle()
        : await auth.signInWithGoogle();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'تم تسجيل الدخول بنجاح' : (errorMessage ?? 'حدث خطأ. حاول مرة أخرى')),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: ok ? 2 : 6),
      ),
    );
  }
}

/// زر تسجيل الخروج.
class _SignOutTile extends StatelessWidget {
  const _SignOutTile({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius)),
      child: ListTile(
        leading: Icon(Icons.logout_rounded, color: colorScheme.error),
        title: Text(
          'تسجيل الخروج',
          style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.w600),
        ),
        onTap: () => _onSignOutPressed(context),
      ),
    );
  }

  Future<void> _onSignOutPressed(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final scheme = Theme.of(ctx).colorScheme;
        return AlertDialog(
          title: const Text('تسجيل الخروج'),
          content: const Text('هل تريد تسجيل الخروج؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(AppLocalizations.of(ctx)!.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: FilledButton.styleFrom(backgroundColor: scheme.error),
              child: const Text('تسجيل الخروج'),
            ),
          ],
        );
      },
    );
    if (!context.mounted || ok != true) return;
    await context.read<AuthProvider>().signOut();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تسجيل الخروج'),
        behavior: SnackBarBehavior.floating,
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

class _HijriAdjustmentTile extends StatelessWidget {
  const _HijriAdjustmentTile({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder<int>(
      valueListenable: HijriOffsetService.offsetNotifier,
      builder: (context, offset, _) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, color: colorScheme.primary),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        l10n.hijriDateAdjustmentHint,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.hijriOffsetValue(offset),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: offset <= -2 ? null : () async {
                        await HijriOffsetService.subtractOneDay();
                      },
                      icon: const Icon(Icons.remove_rounded, size: 20),
                      label: Text(l10n.hijriMinusOne),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.tonalIcon(
                      onPressed: offset >= 2 ? null : () async {
                        await HijriOffsetService.addOneDay();
                      },
                      icon: const Icon(Icons.add_rounded, size: 20),
                      label: Text(l10n.hijriPlusOne),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DownloadMushafTile extends StatelessWidget {
  const _DownloadMushafTile({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final downloaded = MushafStorageService.downloadedCount;
    final total = kMushafTotalPages;
    final isComplete = downloaded >= total;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius)),
      child: ListTile(
        leading: Icon(
          isComplete ? Icons.download_done_rounded : Icons.download_rounded,
          color: colorScheme.primary,
        ),
        title: Text(
          l10n.downloadMushafOffline,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
        ),
        subtitle: Text(
          l10n.downloadMushafOfflineHint,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
        ),
        trailing: isComplete ? Icon(Icons.check_circle_rounded, color: colorScheme.primary) : null,
        onTap: () async {
          await MushafStorageService.ensureInit();
          if (!context.mounted) return;
          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => _DownloadMushafDialog(l10n: l10n),
          );
        },
      ),
    );
  }
}

class _DownloadMushafDialog extends StatefulWidget {
  const _DownloadMushafDialog({required this.l10n});

  final AppLocalizations l10n;

  @override
  State<_DownloadMushafDialog> createState() => _DownloadMushafDialogState();
}

class _DownloadMushafDialogState extends State<_DownloadMushafDialog> {
  int _current = 0;
  bool _cancelled = false;
  bool _done = false;
  String? _error;

  static const int _total = kMushafTotalPages;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startDownload());
  }

  Future<void> _startDownload() async {
    await MushafStorageService.downloadAllMushafPages(
      onProgress: (current, total) {
        if (_cancelled) return;
        if (mounted) setState(() => _current = current);
      },
      isCancelled: () => _cancelled,
    );
    if (!mounted) return;
    setState(() => _done = true);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = _total > 0 ? _current / _total : 0.0;

    return AlertDialog(
      title: Text(widget.l10n.downloadMushafOffline),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.l10n.downloadMushafOfflineHint,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(value: _done ? 1.0 : progress),
          const SizedBox(height: 8),
          Text(
            widget.l10n.downloadingPage(_current, _total),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (_done) ...[
            const SizedBox(height: 12),
            Text(
              MushafStorageService.downloadedCount >= _total
                  ? widget.l10n.downloadComplete
                  : widget.l10n.downloadPartial(MushafStorageService.downloadedCount, _total),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          if (_error != null) ...[const SizedBox(height: 8), Text(_error!, style: TextStyle(color: colorScheme.error))],
        ],
      ),
      actions: [
        if (!_done)
          TextButton(
            onPressed: () {
              setState(() => _cancelled = true);
              Navigator.of(context).pop();
            },
            child: Text(widget.l10n.cancel),
          ),
        if (_done)
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(widget.l10n.done),
          ),
      ],
    );
  }
}

class _PrivacyPolicyTile extends StatelessWidget {
  const _PrivacyPolicyTile({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius)),
      child: ListTile(
        leading: Icon(Icons.privacy_tip_outlined, color: colorScheme.primary),
        title: Text(l10n.privacyPolicy),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const PrivacyPolicyScreen()),
        ),
      ),
    );
  }
}

class _VersionTile extends StatelessWidget {
  const _VersionTile({required this.l10n, required this.colorScheme});

  final AppLocalizations l10n;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius)),
      child: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          final version = snapshot.data?.version ?? '—';
          final buildNumber = snapshot.data?.buildNumber;
          final versionText = buildNumber != null && buildNumber.isNotEmpty
              ? '$version (${l10n.build} $buildNumber)'
              : version;
          return ListTile(
            leading: Icon(Icons.tag_rounded, color: colorScheme.primary),
            title: Text(l10n.version),
            trailing: Text(
              versionText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
            ),
          );
        },
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
        subtitle: Text(l10n.appTitle),
      ),
    );
  }
}
