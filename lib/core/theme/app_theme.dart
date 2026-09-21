import 'package:flutter/material.dart';
import '../utils/startup_trace.dart';

class AppTheme {
  // Modern Enterprise Colors
  static const Color primaryBlue = Color(0xFF1E40AF); // Professional Blue
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surfaceContainer = Color(0xFFF8FAFC);
  static const Color textMain = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textGrey = Color(0xFF64748B); // Compatibility
  static const Color outline = Color(0xFFE2E8F0);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B); // Compatibility

  static ThemeData? _lightTheme;

  static ThemeData get lightTheme {
    if (_lightTheme != null) return _lightTheme!;
    
    debugPrint('[STARTUP] AppTheme initializing lightTheme: ${startupStopwatch.elapsedMilliseconds}ms');
    _lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: accentBlue,
        surface: backgroundLight,
        onSurface: textMain,
        error: error,
        outline: textMuted,
        surfaceContainerLow: surfaceContainer,
      ),
      scaffoldBackgroundColor: backgroundLight,
      textTheme: _buildTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundLight,
        foregroundColor: textMain,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textMain,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: backgroundLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: outline),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(64, 48),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: primaryBlue.withValues(alpha: 0.1),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryBlue, size: 26);
          }
          return const IconThemeData(color: textMuted, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 12);
          }
          return const TextStyle(color: textMuted, fontWeight: FontWeight.w500, fontSize: 12);
        }),
      ),
    );
    debugPrint('[STARTUP] AppTheme lightTheme initialized: ${startupStopwatch.elapsedMilliseconds}ms');
    return _lightTheme!;
  }

  static TextTheme _buildTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: textMain, letterSpacing: -0.5),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: textMain, letterSpacing: -0.5),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textMain),
      bodyLarge: TextStyle(fontSize: 16, color: textMain, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, color: textMain),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textMuted),
    );
  }
}
