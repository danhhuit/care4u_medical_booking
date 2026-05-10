import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  SettingsManager._();

  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier<ThemeMode>(
    ThemeMode.light,
  );

  static final ValueNotifier<String> languageCode = ValueNotifier<String>('vi');

  static bool _isLoggedIn = false;
  static bool get isLoggedIn => _isLoggedIn;

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    
    // Load config
    final savedTheme = _prefs.getString('theme_mode');
    if (savedTheme != null) {
      themeMode.value = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    }

    final savedLang = _prefs.getString('language_code');
    if (savedLang != null) {
      languageCode.value = savedLang;
    }

    _isLoggedIn = _prefs.getBool('is_logged_in') ?? false;
  }

  static void toggleTheme(bool isDark) async {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    await _prefs.setString('theme_mode', isDark ? 'dark' : 'light');
  }

  static void setLanguage(String code) async {
    languageCode.value = code;
    await _prefs.setString('language_code', code);
  }

  static Future<void> setLoggedIn(bool value) async {
    _isLoggedIn = value;
    await _prefs.setBool('is_logged_in', value);
  }

  static bool get isDarkMode => themeMode.value == ThemeMode.dark;
  static String get currentLanguage => languageCode.value;
}
