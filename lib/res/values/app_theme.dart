import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryYellow,
        onPrimary: AppColors.black,
        primaryContainer: AppColors.primaryYellowLight,
        onPrimaryContainer: AppColors.black,
        
        secondary: AppColors.secondaryDarkBlue,
        onSecondary: AppColors.white,
        secondaryContainer: AppColors.secondaryBlue,
        onSecondaryContainer: AppColors.white,
        
        tertiary: AppColors.secondaryLightBlue,
        onTertiary: AppColors.white,
        
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceVariant: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        
        background: AppColors.white,
        onBackground: AppColors.black,
        
        error: AppColors.error,
        onError: AppColors.onError,
        
        outline: AppColors.mediumGray,
        shadow: AppColors.black,
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryYellow,
        foregroundColor: AppColors.black,
        elevation: 0,
        centerTitle: true,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryYellow,
          foregroundColor: AppColors.black,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.secondaryDarkBlue,
          side: const BorderSide(color: AppColors.secondaryDarkBlue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryYellow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.mediumGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.mediumGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryYellow, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primaryYellow,
        unselectedItemColor: AppColors.secondaryLightBlue,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryYellow,
        foregroundColor: AppColors.black,
        elevation: 6,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryYellow,
        onPrimary: AppColors.black,
        primaryContainer: AppColors.primaryYellowDark,
        onPrimaryContainer: AppColors.black,
        
        secondary: AppColors.secondaryBlue,
        onSecondary: AppColors.white,
        secondaryContainer: AppColors.secondaryLightBlue,
        onSecondaryContainer: AppColors.white,
        
        tertiary: AppColors.primaryYellowLight,
        onTertiary: AppColors.black,
        
        surface: AppColors.secondaryDarkBlue,
        onSurface: AppColors.white,
        surfaceVariant: AppColors.secondaryBlue,
        onSurfaceVariant: AppColors.lightGray,
        
        background: AppColors.black,
        onBackground: AppColors.white,
        
        error: AppColors.error,
        onError: AppColors.white,
        
        outline: AppColors.secondaryLightBlue,
        shadow: AppColors.black,
      ),
      // Additional dark theme configurations can be added here
    );
  }
}