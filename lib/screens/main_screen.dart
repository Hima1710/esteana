import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../hooks/use_l10n.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../services/app_permissions_service.dart';
import '../theme/app_theme.dart';
import '../widgets/luminous_floating_box.dart';
import 'settings_screen.dart';
import 'tabs/mihrab_tab.dart';
import 'tabs/athari_tab.dart';
import 'tabs/majlis_tab.dart';
import 'tabs/zad_tab.dart';

/// الشاشة الرئيسية — شريط علوي، تابات (المحراب، أثري، المجلس، زاد)، شريط تنقل سفلي طافي.
class MainScreen extends HookWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);
    final l10n = useL10n();

    useEffect(() {
      Future.delayed(const Duration(milliseconds: 600), requestAppPermissionsAtStartup);
      return null;
    }, []);
    final locale = context.select<LocaleProvider, Locale?>((p) => p.locale);

    final tabs = [
      _TabInfo(title: l10n.mihrab, icon: Icons.mosque_rounded, body: const MihrabTab()),
      _TabInfo(title: l10n.athari, icon: Icons.check_circle_outline_rounded, body: const AthariTab()),
      _TabInfo(title: l10n.majlis, icon: Icons.groups_rounded, body: const MajlisTab()),
      _TabInfo(title: l10n.zad, icon: Icons.play_circle_outline_rounded, body: const ZadTab()),
    ];

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final barShape = BorderRadius.only(
      bottomLeft: Radius.circular(kShapeRadius),
      bottomRight: Radius.circular(kShapeRadius),
    );
    final overlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: const Color(0x00000000),
      systemNavigationBarDividerColor: const Color(0x00000000),
      systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    );
    final gradient = AppGradients.gradientFor(theme.brightness);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(gradient: gradient),
          ),
          AnnotatedRegion<SystemUiOverlayStyle>(
            value: overlayStyle,
            child: Column(
          children: [
            SafeArea(
              bottom: false,
              child: ClipRRect(
                borderRadius: barShape,
                child: Container(
                  height: kToolbarHeight,
                  color: colorScheme.surface,
                  child: Row(
                    children: [
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
                      Expanded(
                        child: Text(
                          tabs[currentIndex.value].title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      _AppBarProfileAvatar(colorScheme: colorScheme),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Stack(
                children: [
                  IndexedStack(
                    index: currentIndex.value,
                    children: tabs.map((t) => t.body).toList(),
                  ),
                  RepaintBoundary(child: const LuminousFloatingBox()),
                ],
              ),
            ),
          ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.12),
                blurRadius: 16,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Theme(
              data: theme.copyWith(
                navigationBarTheme: NavigationBarThemeData(
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  height: 70,
                  indicatorColor: colorScheme.primaryContainer,
                  labelTextStyle: WidgetStateProperty.resolveWith((_) => TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  )),
                ),
              ),
              child: NavigationBar(
                selectedIndex: currentIndex.value,
                onDestinationSelected: (i) => currentIndex.value = i,
                destinations: tabs
                    .map((t) => NavigationDestination(
                          icon: Icon(t.icon),
                          label: t.title,
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// صورة البروفايل في الشريط العلوي — دائماً ظاهرة فوق.
class _AppBarProfileAvatar extends StatelessWidget {
  const _AppBarProfileAvatar({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    const double size = 36;
    final user = Supabase.instance.client.auth.currentUser;
    final auth = context.watch<AuthProvider>();
    final meta = user?.userMetadata;
    String? avatarUrl;
    if (auth.isSignedIn && meta != null && meta['avatar_url'] != null) {
      avatarUrl = meta['avatar_url'] as String?;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
        ),
        borderRadius: BorderRadius.circular(size / 2),
        child: avatarUrl != null && avatarUrl.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(size / 2),
                child: Image.network(
                  avatarUrl,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _placeholder(size),
                ),
              )
            : _placeholder(size),
      ),
    );
  }

  Widget _placeholder(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person_rounded,
        size: size * 0.55,
        color: colorScheme.onSurfaceVariant,
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
