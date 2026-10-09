import 'package:flutter/material.dart';
import '../models/note_model.dart';
import 'package:google_fonts/google_fonts.dart';

// Warm neutral palette from the latest reference design
class AppColors {
  static const Color charcoal = Color(0xFF2B2338);
  static const Color iris = Color(0xFF5A4FCF);
  static const Color accent = Color(0xFFA79AE8);
  static const Color cream = Color(0xFFFFF8DC);
  static const Color mist = Color(0xFFF5EDB8);
  static const Color danger = Color(0xFFC0473E);

  static const Color personal = Color(0xFFF2D06B);
  static const Color work = Color(0xFF8FAF8C);
  static const Color study = Color(0xFFB6A6E8);
  static const Color other = Color(0xFFE8B04A);
}

class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness b) {
    final isDark = b == Brightness.dark;

    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.iris,
      brightness: b,
    ).copyWith(
      primary: isDark ? const Color(0xFF8A7AE8) : AppColors.iris,
      onPrimary: Colors.white,
      secondary: AppColors.accent,
      surface: isDark ? const Color(0xFF241D33) : Colors.white,
      onSurface: isDark ? const Color(0xFFF5EDB8) : AppColors.charcoal,
      error: AppColors.danger,
    );

    final base = ThemeData(useMaterial3: true, brightness: b, colorScheme: scheme);

    OutlineInputBorder border(Color c, {double w = 1}) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c, width: w),
        );

    return base.copyWith(
      scaffoldBackgroundColor: isDark ? const Color(0xFF1C1815) : AppColors.cream,
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: scheme.onSurface,
        titleTextStyle: GoogleFonts.poppins(
            fontSize: 24, fontWeight: FontWeight.w600, color: scheme.onSurface),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: isDark ? const Color(0xFF332C26) : AppColors.mist,
        selectedColor: AppColors.iris,
        labelStyle: TextStyle(color: scheme.onSurface),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        shape: const StadiumBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        border: border(isDark ? Colors.white24 : Colors.black12),
        enabledBorder: border(isDark ? Colors.white24 : Colors.black12),
        focusedBorder: border(AppColors.iris, w: 1.6),
        errorBorder: border(scheme.error, w: 1.4),
        focusedErrorBorder: border(scheme.error, w: 1.6),
      ),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    );
  }
}

// Category -> (icon, color) used for note tiles throughout the app
class CategoryStyle {
  static IconData icon(NoteCategory category) {
    switch (category) {
      case NoteCategory.work: return Icons.work_outline;
      case NoteCategory.study: return Icons.menu_book_outlined;
      case NoteCategory.other: return Icons.label_outline;
      case NoteCategory.personal: return Icons.lightbulb_outline;
    }
  }

  static Color color(NoteCategory category) {
    switch (category) {
      case NoteCategory.work: return AppColors.work;
      case NoteCategory.study: return AppColors.study;
      case NoteCategory.other: return AppColors.other;
      case NoteCategory.personal: return AppColors.personal;
    }
  }
}