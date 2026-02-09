import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kThemeModeKey = 'app_theme_mode';

/// يحفظ وضع المظهر (system / light / dark) في SharedPreferences.
class ThemeModeProvider extends ChangeNotifier {
  ThemeModeProvider({ThemeMode? initialMode}) : _mode = initialMode ?? ThemeMode.system;

  ThemeMode _mode;

  ThemeMode get themeMode => _mode;

  void setThemeMode(ThemeMode value) {
    if (_mode == value) return;
    _mode = value;
    _persist(value);
    notifyListeners();
  }

  Future<void> _persist(ThemeMode value) async {
    final prefs = await SharedPreferences.getInstance();
    final str = value == ThemeMode.system
        ? 'system'
        : value == ThemeMode.light
            ? 'light'
            : 'dark';
    await prefs.setString(_kThemeModeKey, str);
  }

  static Future<ThemeMode?> loadSavedThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_kThemeModeKey);
    if (str == null) return null;
    switch (str) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
