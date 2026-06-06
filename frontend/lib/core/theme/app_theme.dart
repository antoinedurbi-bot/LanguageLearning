import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get light {
    const ink = Color(0xFF14213D);
    const coral = Color(0xFFE76F51);
    const mint = Color(0xFF2A9D8F);
    const paper = Color(0xFFFAFAF7);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: mint,
        primary: mint,
        secondary: coral,
        surface: paper,
      ),
      scaffoldBackgroundColor: paper,
      textTheme: GoogleFonts.interTextTheme().apply(bodyColor: ink, displayColor: ink),
      appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
