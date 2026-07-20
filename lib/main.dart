import 'package:flutter/material.dart';
import 'package:newsapp/app.dart';
import 'package:newsapp/core/config/app_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.validate();
  runApp(const App());
}
  
