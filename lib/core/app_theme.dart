import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class C {
  static const green = Color(0xFF12634F);
  static const deep = Color(0xFF103C33);
  static const mint = Color(0xFFE5F3EC);
  static const canvas = Color(0xFFF6F8F6);
  static const ink = Color(0xFF1B302A);
  static const muted = Color(0xFF73827B);
  static const line = Color(0xFFE5EAE7);
  static const gold = Color(0xFFCF8F33);
  static const red = Color(0xFFB54848);
}

ThemeData appTheme() {
  final poppins = GoogleFonts.poppins().fontFamily;

  return ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor: C.canvas,

    colorScheme: ColorScheme.fromSeed(
      seedColor: C.green,
      primary: C.green,
      surface: Colors.white,
    ),

    // FONT GLOBAL
    fontFamily: poppins,

    // Warna teks tetap seperti sebelumnya.
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: C.ink),
      bodyMedium: TextStyle(color: C.ink),
      bodySmall: TextStyle(color: C.ink),
      titleLarge: TextStyle(color: C.ink),
      titleMedium: TextStyle(color: C.ink),
      titleSmall: TextStyle(color: C.ink),
      labelLarge: TextStyle(color: C.ink),
      labelMedium: TextStyle(color: C.ink),
      labelSmall: TextStyle(color: C.ink),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: C.canvas,
      elevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
      foregroundColor: C.ink,
      titleTextStyle: GoogleFonts.poppins(
        color: C.ink,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: C.line),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 17),
      hintStyle: GoogleFonts.poppins(color: C.muted),
      labelStyle: GoogleFonts.poppins(color: C.muted),
      floatingLabelStyle: GoogleFonts.poppins(color: C.green),
      errorStyle: GoogleFonts.poppins(color: C.red),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: C.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: C.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: C.green, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: C.red),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: C.green,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: C.green,
        minimumSize: const Size.fromHeight(52),
        side: const BorderSide(color: C.line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(textStyle: GoogleFonts.poppins()),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      height: 75,
      indicatorColor: C.mint,
      labelTextStyle: WidgetStateProperty.all(
        GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600),
      ),
    ),

    dialogTheme: DialogThemeData(
      titleTextStyle: GoogleFonts.poppins(
        color: C.ink,
        fontSize: 19,
        fontWeight: FontWeight.w700,
      ),
      contentTextStyle: GoogleFonts.poppins(color: C.muted, fontSize: 13),
    ),

    snackBarTheme: SnackBarThemeData(
      contentTextStyle: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
    ),

    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: GoogleFonts.poppins(color: C.ink),
    ),

    tooltipTheme: TooltipThemeData(
      textStyle: GoogleFonts.poppins(fontSize: 12, color: C.ink),
    ),
  );
}
