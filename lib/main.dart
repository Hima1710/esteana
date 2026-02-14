import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'generated/l10n/app_localizations.dart';
import 'services/hijri_offset_service.dart';
import 'services/isar_service.dart';
import 'services/seed_service.dart';
import 'theme/app_theme.dart';
import 'screens/splash_landing_screen.dart';
import 'screens/main_screen.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_mode_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/call_state_provider.dart';
import 'utils/app_route_observer.dart';
import 'widgets/pulsing_call_indicator.dart';

const String _kHasStartedJourneyKey = 'has_started_journey';

void _syncAuthFromSession(AuthProvider authProvider, Session? session) {
  if (session == null) {
    authProvider.setGuest();
    return;
  }
  if (session.user.isAnonymous) {
    authProvider.setAnonymous();
  } else {
    authProvider.setSignedIn();
  }
}

/// مفتاح الـ Navigator للانتقال بعد نجاح OAuth من Deep Link.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
StreamSubscription<AuthState>? _authStateSubscription;

/// true = إظهار مؤشر الأداء (الرسمين العلويين) عند التشغيل بـ flutter run.
bool _kShowPerformanceOverlay = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // edge-to-edge: المحتوى يمتد خلف شريط الحالة والتنقل، بدون مساحات بيضاء
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Color(0x00000000),
    systemNavigationBarDividerColor: Color(0x00000000),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  await Supabase.initialize(url: SupabaseConfig.url, anonKey: SupabaseConfig.anonKey);
  await IsarService.init();
  await runAllSeeds();

  final prefs = await SharedPreferences.getInstance();
  await HijriOffsetService.loadOffset();
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
        ChangeNotifierProvider(create: (_) => CallState()),
      ],
      child: TheMuslimJourneyApp(
        navigatorKey: rootNavigatorKey,
        initialHome: hasStartedJourney ? const MainScreen() : const SplashLandingScreen(),
      ),
    ),
  );
}

class TheMuslimJourneyApp extends StatefulWidget {
  const TheMuslimJourneyApp({
    super.key,
    required this.navigatorKey,
    required this.initialHome,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final Widget initialHome;

  @override
  State<TheMuslimJourneyApp> createState() => _TheMuslimJourneyAppState();
}

class _TheMuslimJourneyAppState extends State<TheMuslimJourneyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      _syncAuthFromSession(authProvider, Supabase.instance.client.auth.currentSession);
      _authStateSubscription?.cancel();
      _authStateSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
        _syncAuthFromSession(authProvider, data.session);
      });
    });
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final themeModeProvider = context.watch<ThemeModeProvider>();
    return MaterialApp(
      navigatorKey: widget.navigatorKey,
      navigatorObservers: [appRouteObserver],
      title: 'Esteana',
      theme: AppTheme.lightTheme(localeProvider.locale),
      darkTheme: AppTheme.darkTheme(localeProvider.locale),
      themeMode: themeModeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      locale: localeProvider.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      scrollBehavior: const AppScrollBehavior(),
      showPerformanceOverlay: kDebugMode && _kShowPerformanceOverlay,
      home: widget.initialHome,
      builder: (context, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            if (child != null) Positioned.fill(child: child),
            const PulsingCallIndicator(),
          ],
        );
      },
    );
  }
}
