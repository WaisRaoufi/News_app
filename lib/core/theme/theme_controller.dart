import 'package:flutter/material.dart';

class ThemeController {
  ThemeController._();

  static final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier(ThemeMode.light);

  static bool get isDarkMode => themeMode.value == ThemeMode.dark;

  static void toggleTheme() {
    themeMode.value =
        isDarkMode ? ThemeMode.light : ThemeMode.dark;
  }

  static void setLightMode() {
    themeMode.value = ThemeMode.light;
  }

  static void setDarkMode() {
    themeMode.value = ThemeMode.dark;
  }
}