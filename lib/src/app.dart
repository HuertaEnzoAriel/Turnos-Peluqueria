import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/main_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peluquería',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      initialRoute: 'login',
      routes: {
        'login': (context) => LoginPage(),
        'home': (context) => MainPage(),
      },
    );
  }
}