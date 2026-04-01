import 'package:flutter/material.dart';

class SettingsManager {
  SettingsManager._();

  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier<ThemeMode>(
    ThemeMode.light,
  );

  static final ValueNotifier<String> languageCode = ValueNotifier<String>('vi');

  static void toggleTheme(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  static void setLanguage(String code) {
    languageCode.value = code;
  }

  static bool get isDarkMode => themeMode.value == ThemeMode.dark;
  static String get currentLanguage => languageCode.value;
}
