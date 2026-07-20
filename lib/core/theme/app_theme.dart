import 'package:flutter/material.dart';
import 'package:newsapp/core/constants/app_colors.dart';
import 'package:newsapp/core/constants/app_fonts.dart';
import 'package:newsapp/core/constants/app_sizes.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light(String languageCode) {
    final fontFamily = AppFonts.englishFontLanguage();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightBackground,
        surface: AppColors.lightSurface,
        primaryContainer: AppColors.lightTextPrimary,
        surfaceContainer: AppColors.lightTextSecondary
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.lightTextPrimary,
      ),
      iconTheme: const IconThemeData(color: AppColors.lightTextSecondary),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium)
        )
      )
    );
  }

  static ThemeData dark(String languageCode) {
    final fontFamily = AppFonts.englishFontLanguage();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkBackground,
        surface: AppColors.darkSurface,
        primaryContainer: AppColors.darkTextPrimary,
        surfaceContainer: AppColors.darkTextSecondary
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.darkTextPrimary,
      ),
      iconTheme: const IconThemeData(color: AppColors.darkTextSecondary),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium)
        )
      )
    );
  }
}
