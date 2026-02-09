import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'generated/l10n/app_localizations.dart';
import 'services/isar_service.dart';
import 'services/seed_service.dart';
import 'theme/app_theme.dart';
import 'screens/splash_landing_screen.dart';
import 'screens/main_screen.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_mode_provider.dart';
import 'providers/auth_provider.dart';

const String _kHasStartedJourneyKey = 'has_started_journey';

/// true = إظهار مؤشر الأداء (الرسمين العلويين) عند التشغيل بـ flutter run.
bool _kShowPerformanceOverlay = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: SupabaseConfig.url, anonKey: SupabaseConfig.anonKey);
  await IsarService.init();
  await runAllSeeds();

  final prefs = await SharedPreferences.getInstance();
  final savedLocaleCode = prefs.getString('app_locale');
  final savedLocale = savedLocaleCode != null ? Locale(savedLocaleCode) : null;
  final savedThemeMode = await ThemeModeProvider.loadSavedThemeMode();
  final hasStartedJourney = prefs.getBool(_kHasStartedJourneyKey) ?? false;

  runApp(
    MultiProvider(
      providers: [
        Provider<Isar>.value(value: IsarService.isar),
        ChangeNotifierProvider(create: (_) => LocaleProvider(initialLocale: savedLocale)),
        ChangeNotifierProvider(create: (_) => ThemeModeProvider(initialMode: savedThemeMode)),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: TheMuslimJourneyApp(initialHome: hasStartedJourney ? const MainScreen() : const SplashLandingScreen()),
    ),
  );
}

class TheMuslimJourneyApp extends StatelessWidget {
  const TheMuslimJourneyApp({super.key, required this.initialHome});

  final Widget initialHome;

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final themeModeProvider = context.watch<ThemeModeProvider>();
    return MaterialApp(
      title: 'Istiana',
      theme: AppTheme.lightTheme(localeProvider.locale),
      darkTheme: AppTheme.darkTheme(localeProvider.locale),
      themeMode: themeModeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      locale: localeProvider.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      scrollBehavior: const AppScrollBehavior(),
      /// في وضع التطوير: اضبط true لرؤية مؤشر الإطارات (أخضر = سلس، أحمر = لاج).
      showPerformanceOverlay: kDebugMode && _kShowPerformanceOverlay,
      home: initialHome,
    );
  }
}
