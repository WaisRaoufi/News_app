import 'package:flutter/material.dart';
import 'package:newsapp/core/constants/app_colors.dart';
import 'package:newsapp/core/constants/app_fonts.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme light() {
    return  TextTheme(
      headlineLarge: TextStyle(
        fontFamily: AppFonts.primary,
        fontSize: 22,
        color: AppColors.lightTextPrimary,
      ),
      bodyLarge: TextStyle(
        fontFamily: AppFonts.primary,
        fontSize: 16,
        color: AppColors.lightTextSecondary,
      ),
      bodyMedium: TextStyle(
        fontFamily: AppFonts.primary,
        fontSize: 14,
        color: AppColors.lightTextSecondary,
      ),
    );
  }

  static TextTheme dark() {
    return  TextTheme(
      headlineLarge: TextStyle(
        fontFamily: AppFonts.primary,
        fontSize: 22,
        color: AppColors.darkTextPrimary,
      ),
      bodyLarge: TextStyle(
        fontFamily: AppFonts.primary,
        fontSize: 16,
        color: AppColors.darkTextSecondary,
      ),
      bodyMedium: TextStyle(
        fontFamily: AppFonts.primary,
        fontSize: 14,
        color: AppColors.darkTextSecondary,
      ),
    
    );
  }
}