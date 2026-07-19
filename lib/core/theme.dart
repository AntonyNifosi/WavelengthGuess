import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Couleurs du thème Wavelength — dark/néon.
class WavelengthColors {
  WavelengthColors._();

  // --- Fond ---
  static const Color background = Color(0xFF0A0E1A);
  static const Color surface = Color(0xFF131829);
  static const Color surfaceLight = Color(0xFF1C2237);

  // --- Accents néon ---
  static const Color cyan = Color(0xFF00F0FF);
  static const Color violet = Color(0xFFA855F7);
  static const Color pink = Color(0xFFFF2D95);
  static const Color green = Color(0xFF00FF88);
  static const Color orange = Color(0xFFFF8A00);
  static const Color yellow = Color(0xFFFFE135);

  // --- Texte ---
  static const Color textPrimary = Color(0xFFF0F0F5);
  static const Color textSecondary = Color(0xFF8B8FA8);
  static const Color textMuted = Color(0xFF505470);

  // --- Dial ---
  static const List<Color> dialGradient = [
    Color(0xFFFF2D95), // rose
    Color(0xFFA855F7), // violet
    Color(0xFF6366F1), // indigo
    Color(0xFF00F0FF), // cyan
    Color(0xFF00FF88), // vert
    Color(0xFFFFE135), // jaune
    Color(0xFFFF8A00), // orange
  ];

  // --- Scoring zones ---
  static const Color bullseye = Color(0xFFFFE135);
  static const Color closeZone = Color(0xFFFF8A00);
  static const Color farZone = Color(0xFFA855F7);

  // --- Glass ---
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassBackground = Color(0x15FFFFFF);
}

/// Thème de l'application Wavelength.
class WavelengthTheme {
  WavelengthTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: WavelengthColors.background,
      colorScheme: ColorScheme.dark(
        surface: WavelengthColors.surface,
        primary: WavelengthColors.cyan,
        secondary: WavelengthColors.violet,
        onPrimary: WavelengthColors.background,
        onSecondary: WavelengthColors.textPrimary,
        onSurface: WavelengthColors.textPrimary,
      ),
      textTheme: GoogleFonts.outfitTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.outfit(
          fontSize: 48,
          fontWeight: FontWeight.w800,
          color: WavelengthColors.textPrimary,
          letterSpacing: 2,
        ),
        displayMedium: GoogleFonts.outfit(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: WavelengthColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: WavelengthColors.textPrimary,
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: WavelengthColors.textPrimary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: WavelengthColors.textSecondary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: WavelengthColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: WavelengthColors.textSecondary,
        ),
        labelLarge: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: WavelengthColors.textPrimary,
          letterSpacing: 1,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: WavelengthColors.cyan,
          foregroundColor: WavelengthColors.background,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: WavelengthColors.cyan,
          side: const BorderSide(color: WavelengthColors.cyan, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
