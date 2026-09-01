import 'package:flutter/material.dart';
import '../utils/startup_utils.dart';

class AppTheme {
  // Corporate Colors
  static const Color primaryBlue = Color(0xFF1A237E); // Deep Navy
  static const Color accentBlue = Color(0xFF3F51B5);
  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color white = Colors.white;
  static const Color textDark = Color(0xFF212121);
  static const Color textGrey = Color(0xFF757575);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE57373);
  static const Color warning = Color(0xFFFFB74D);

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
        surface: white,
        error: error,
      ),
      scaffoldBackgroundColor: backgroundLight,
      textTheme: _buildTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: white,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
    debugPrint('[STARTUP] AppTheme lightTheme initialized: ${startupStopwatch.elapsedMilliseconds}ms');
    return _lightTheme!;
  }

  static TextTheme _buildTextTheme() {
    debugPrint('[STARTUP] AppTheme building textTheme: ${startupStopwatch.elapsedMilliseconds}ms');
    return const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textDark),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textDark),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textDark),
      bodyLarge: TextStyle(fontSize: 16, color: textDark),
      bodyMedium: TextStyle(fontSize: 14, color: textDark),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textGrey),
    );
  }
}
