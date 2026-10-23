import 'package:flutter/material.dart';
import 'src/app_theme.dart';
import 'src/pages/routes/routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peluquería',
      theme: appTheme,
      initialRoute: '/',
      routes: getAplicationRoutes(),
    );
  }
}
