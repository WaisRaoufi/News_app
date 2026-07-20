import 'package:flutter/material.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme textTheme({
    required String fontFamily,
    required Color primaryTextColor,
    required Color secondaryTextColor,
  }) {
    return TextTheme(
      headlineLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        color: primaryTextColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        fontFamily: fontFamily,
        color: secondaryTextColor,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        color: secondaryTextColor,
      ),
    );
  }
}
