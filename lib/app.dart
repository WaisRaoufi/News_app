import 'package:flutter/material.dart';
import 'package:newsapp/core/theme/app_theme.dart';
import 'package:newsapp/core/theme/theme_controller.dart';
import 'package:newsapp/features/home/pages/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeMode,
      builder: (context, themeMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          theme: AppTheme.light,
          darkTheme: AppTheme.dark,

          themeMode: themeMode,

          home: const HomePage(),
        );
      },
    );
  }
}