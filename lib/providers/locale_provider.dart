import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kLocaleKey = 'app_locale';

/// يوفّر اللغة الحالية ويمكّن التبديل بين ar و en مع تغيير اتجاه الواجهة (RTL/LTR).
/// اللغة تُحفظ في SharedPreferences لتبقى بعد إغلاق التطبيق.
class LocaleProvider extends ChangeNotifier {
  LocaleProvider({Locale? initialLocale}) {
    _locale = initialLocale;
  }

  Locale? _locale;

  Locale? get locale => _locale;

  bool get isArabic => _locale?.languageCode == 'ar';

  void setLocale(Locale? value) {
    if (_locale == value) return;
    _locale = value;
    _persistLocale(value?.languageCode);
    notifyListeners();
  }

  void toggleLocale() {
    _locale = isArabic ? const Locale('en') : const Locale('ar');
    _persistLocale(_locale?.languageCode);
    notifyListeners();
  }

  void _persistLocale(String? code) {
    SharedPreferences.getInstance().then((prefs) {
      if (code == null) {
        prefs.remove(_kLocaleKey);
      } else {
        prefs.setString(_kLocaleKey, code);
      }
    });
  }
}
