import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// سلوك تمرير سلس — BouncingScrollPhysics على كل المنصات للانزلاق السلس.
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  }
}

/// نصف قطر موحد للمواد 3 — 24dp
const double kShapeRadius = 24;

/// ألوان مرجعية (للتدرجات والاستخدام عند الحاجة فقط — يُفضّل colorScheme).
class AppColors {
  AppColors._();

  static const Color tealDark = Color(0xFF004D40);
  static const Color tealMid = Color(0xFF00695C);
  static const Color tealLight = Color(0xFF00897B);
  static const Color tealSurface = Color(0xFFE0F2F1);
  static const Color tealOnDark = Color(0xFFE0F2F1);
  static const Color white = Color(0xFFFFFFFF);
  // للوضع الليلي — خلفيات زيتية غامقة جداً / رمادي داكن
  static const Color darkBgStart = Color(0xFF0D1F1C);
  static const Color darkBgMid = Color(0xFF132A26);
  static const Color darkBgEnd = Color(0xFF1A3630);

  /// لون ورق المصحف القديم — خلفية شاشات المصحف لراحة العين.
  static const Color mushafPaper = Color(0xFFF4E9DC);
}

/// التدرج اللوني — استخدم للخلفية حسب الوضع (انظر AppGradients.gradientFor).
class AppGradients {
  AppGradients._();

  static const LinearGradient tealGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.tealDark,
      AppColors.tealMid,
      AppColors.tealLight,
    ],
  );

  static const LinearGradient tealGradientSoft = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00695C),
      Color(0xFF00897B),
      Color(0xFF26A69A),
    ],
  );

  /// تدرج الوضع الليلي — زيتي غامق جداً / رمادي داكن لراحة العين.
  static const LinearGradient tealGradientDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.darkBgStart,
      AppColors.darkBgMid,
      AppColors.darkBgEnd,
    ],
  );

  /// يُرجع التدرج المناسب لـ [brightness].
  static LinearGradient gradientFor(Brightness brightness) {
    return brightness == Brightness.dark ? tealGradientDark : tealGradient;
  }
}

/// ثيمات Material 3 — نهاري وليلي، مع دعم اللغة (خطوط).
class AppTheme {
  AppTheme._();

  static ThemeData _baseTheme({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kShapeRadius),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(kShapeRadius),
            bottomRight: Radius.circular(kShapeRadius),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: brightness == Brightness.dark ? Brightness.light : Brightness.dark,
          statusBarBrightness: brightness == Brightness.dark ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: const Color(0x00000000),
          systemNavigationBarDividerColor: const Color(0x00000000),
          systemNavigationBarIconBrightness: brightness == Brightness.dark ? Brightness.light : Brightness.dark,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 70,
        elevation: 2,
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((_) => TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        )),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLow,
        elevation: 1,
        shape: shape,
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: shape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(shape: shape),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(shape: shape),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(kShapeRadius)),
        filled: true,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        linearTrackColor: colorScheme.surfaceContainerHighest,
        color: colorScheme.primary,
      ),
    );
  }

  /// الثيم النهاري — ColorScheme.fromSeed(teal).
  static ThemeData lightTheme([Locale? locale]) {
    final isArabic = locale?.languageCode == 'ar';
    final textTheme = isArabic
        ? GoogleFonts.tajawalTextTheme()
        : GoogleFonts.plusJakartaSansTextTheme();
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: Brightness.light,
      primary: AppColors.tealMid,
      surface: AppColors.tealSurface,
    );
    return _baseTheme(
      brightness: Brightness.light,
      colorScheme: colorScheme,
      textTheme: textTheme,
    );
  }

  /// الثيم الليلي — خلفيات زيتية غامقة جداً/رمادي داكن، ألوان متكيفة.
  static ThemeData darkTheme([Locale? locale]) {
    final isArabic = locale?.languageCode == 'ar';
    final textTheme = isArabic
        ? GoogleFonts.tajawalTextTheme(ThemeData.dark().textTheme)
        : GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: Brightness.dark,
      primary: AppColors.tealLight,
    ).copyWith(
      surface: AppColors.darkBgStart,
      surfaceContainerLow: AppColors.darkBgMid,
      surfaceContainerHighest: const Color(0xFF2D4440),
    );
    return _baseTheme(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      textTheme: textTheme,
    );
  }
}
