import 'package:flutter/material.dart';

// Paleta estilo barbería clásica
class AppColores {
  static const Color negro = Color(0xFF1C1C1C);
  static const Color dorado = Color(0xFFC9A227);        // sobre fondos oscuros
  static const Color doradoOscuro = Color(0xFF9A7B1C);  // sobre fondos claros
  static const Color crema = Color(0xFFF8F3E9);
  static const Color bordo = Color(0xFF8B1E2D);
}

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: AppColores.doradoOscuro,
    onPrimary: Colors.white,
    secondary: AppColores.negro,
    onSecondary: AppColores.dorado,
    surface: AppColores.crema,
    onSurface: AppColores.negro,
    error: AppColores.bordo,
  ),
  scaffoldBackgroundColor: AppColores.crema,

  appBarTheme: AppBarTheme(
    backgroundColor: AppColores.negro,
    foregroundColor: AppColores.dorado,
    titleTextStyle: TextStyle(
      color: AppColores.dorado,
      fontSize: 22,
      fontWeight: FontWeight.bold,
      letterSpacing: 2,
    ),
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColores.negro,
    selectedItemColor: AppColores.dorado,
    unselectedItemColor: Colors.grey,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColores.negro,
      foregroundColor: AppColores.dorado,
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: AppColores.doradoOscuro),
  ),

  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: AppColores.dorado, width: 0.5),
    ),
  ),

  dialogTheme: DialogThemeData(
    backgroundColor: AppColores.crema,
    titleTextStyle: TextStyle(
      color: AppColores.negro,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
);
