import 'package:flutter/material.dart';
import '../login_page.dart';
import '../main_page.dart';

Map<String, WidgetBuilder> getAplicationRoutes() {
  return {
    '/': (context) => const LoginPage(),
    'home': (context) => const MainPage(),
  };
}
