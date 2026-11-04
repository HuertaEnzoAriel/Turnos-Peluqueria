import 'package:flutter/material.dart';
import '../crear_cuenta_page.dart';
import '../login_page.dart';
import '../main_page.dart';
import '../servicio_page.dart';

Map<String, WidgetBuilder> getAplicationRoutes() {
  return {
    '/': (context) => const LoginPage(),
    'crear_cuenta': (context) => const CrearCuentaPage(),
    'home': (context) => const MainPage(),
    'servicio': (context) => const ServicioPage(),
  };
}
