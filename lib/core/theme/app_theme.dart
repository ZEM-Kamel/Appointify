import 'package:flutter/material.dart';
import 'package:appointify_app/core/theme/theme_constants.dart';
import 'package:appointify_app/core/utils/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        surface: ThemeConstants.lightSurface,
        background: ThemeConstants.lightBackground,
        error: ThemeConstants.lightError,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: ThemeConstants.lightText,
        onBackground: ThemeConstants.lightText,
        onError: Colors.white,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: ThemeConstants.lightBackground,
      
      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: ThemeConstants.lightAppBar,
        elevation: ThemeConstants.appBarElevation,
        iconTheme: const IconThemeData(color: ThemeConstants.lightIcon),
        titleTextStyle: ThemeConstants.appBarTitleStyle.copyWith(
          color: ThemeConstants.lightText,
        ),
        actionsIconTheme: const IconThemeData(color: ThemeConstants.lightIcon),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ThemeConstants.lightNavBar,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: ThemeConstants.lightSecondaryText,
        elevation: ThemeConstants.cardElevation,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      
      // Cards
      cardTheme: CardTheme(
        color: ThemeConstants.lightCard,
        elevation: ThemeConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
        ),
        margin: EdgeInsets.zero,
      ),
      
      // Text
      textTheme: TextTheme(
        displayLarge: TextStyle(color: ThemeConstants.lightText),
        displayMedium: TextStyle(color: ThemeConstants.lightText),
        displaySmall: TextStyle(color: ThemeConstants.lightText),
        headlineLarge: TextStyle(color: ThemeConstants.lightText),
        headlineMedium: TextStyle(color: ThemeConstants.lightText),
        headlineSmall: TextStyle(color: ThemeConstants.lightText),
        titleLarge: ThemeConstants.cardTitleStyle.copyWith(
          color: ThemeConstants.lightText,
        ),
        titleMedium: TextStyle(color: ThemeConstants.lightText),
        titleSmall: TextStyle(color: ThemeConstants.lightText),
        bodyLarge: TextStyle(color: ThemeConstants.lightText),
        bodyMedium: TextStyle(color: ThemeConstants.lightText),
        bodySmall: TextStyle(color: ThemeConstants.lightSecondaryText),
        labelLarge: TextStyle(color: ThemeConstants.lightText),
        labelMedium: TextStyle(color: ThemeConstants.lightText),
        labelSmall: TextStyle(color: ThemeConstants.lightSecondaryText),
      ),
      
      // Icons
      iconTheme: const IconThemeData(color: ThemeConstants.lightIcon),
      
      // Dividers
      dividerTheme: const DividerThemeData(
        color: ThemeConstants.lightDivider,
        thickness: 1,
        space: 0,
      ),
      
      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeConstants.lightButton,
          foregroundColor: Colors.white,
          elevation: ThemeConstants.buttonElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
          ),
          textStyle: ThemeConstants.buttonTextStyle,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      
      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ThemeConstants.lightInput,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.inputBorderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.inputBorderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.inputBorderRadius),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.inputBorderRadius),
          borderSide: const BorderSide(color: ThemeConstants.lightError),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: TextStyle(color: ThemeConstants.lightSecondaryText),
        labelStyle: TextStyle(color: ThemeConstants.lightSecondaryText),
        errorStyle: TextStyle(color: ThemeConstants.lightError),
      ),
      
      // Dialog
      dialogTheme: DialogTheme(
        backgroundColor: ThemeConstants.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
        ),
        titleTextStyle: TextStyle(
          color: ThemeConstants.lightText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(color: ThemeConstants.lightText),
      ),
      
      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ThemeConstants.lightSurface,
        contentTextStyle: TextStyle(color: ThemeConstants.lightText),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
        ),
        behavior: SnackBarBehavior.floating,
        actionTextColor: AppColors.primaryColor,
      ),

      // Progress Indicators
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primaryColor,
        linearTrackColor: ThemeConstants.lightDivider,
      ),

      // Tooltips
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: ThemeConstants.lightSurface,
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        textStyle: TextStyle(color: ThemeConstants.lightText),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        surface: ThemeConstants.darkSurface,
        background: ThemeConstants.darkBackground,
        error: ThemeConstants.darkError,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: ThemeConstants.darkText,
        onBackground: ThemeConstants.darkText,
        onError: Colors.white,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: ThemeConstants.darkBackground,
      
      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: ThemeConstants.darkAppBar,
        elevation: ThemeConstants.appBarElevation,
        iconTheme: const IconThemeData(color: ThemeConstants.darkIcon),
        titleTextStyle: ThemeConstants.appBarTitleStyle.copyWith(
          color: ThemeConstants.darkText,
        ),
        actionsIconTheme: const IconThemeData(color: ThemeConstants.darkIcon),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ThemeConstants.darkNavBar,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: ThemeConstants.darkSecondaryText,
        elevation: ThemeConstants.cardElevation,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      
      // Cards
      cardTheme: CardTheme(
        color: ThemeConstants.darkCard,
        elevation: ThemeConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
        ),
        margin: EdgeInsets.zero,
      ),
      
      // Text
      textTheme: TextTheme(
        displayLarge: TextStyle(color: ThemeConstants.darkText),
        displayMedium: TextStyle(color: ThemeConstants.darkText),
        displaySmall: TextStyle(color: ThemeConstants.darkText),
        headlineLarge: TextStyle(color: ThemeConstants.darkText),
        headlineMedium: TextStyle(color: ThemeConstants.darkText),
        headlineSmall: TextStyle(color: ThemeConstants.darkText),
        titleLarge: ThemeConstants.cardTitleStyle.copyWith(
          color: ThemeConstants.darkText,
        ),
        titleMedium: TextStyle(color: ThemeConstants.darkText),
        titleSmall: TextStyle(color: ThemeConstants.darkText),
        bodyLarge: TextStyle(color: ThemeConstants.darkText),
        bodyMedium: TextStyle(color: ThemeConstants.darkText),
        bodySmall: TextStyle(color: ThemeConstants.darkSecondaryText),
        labelLarge: TextStyle(color: ThemeConstants.darkText),
        labelMedium: TextStyle(color: ThemeConstants.darkText),
        labelSmall: TextStyle(color: ThemeConstants.darkSecondaryText),
      ),
      
      // Icons
      iconTheme: const IconThemeData(color: ThemeConstants.darkIcon),
      
      // Dividers
      dividerTheme: const DividerThemeData(
        color: ThemeConstants.darkDivider,
        thickness: 1,
        space: 0,
      ),
      
      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeConstants.darkButton,
          foregroundColor: Colors.white,
          elevation: ThemeConstants.buttonElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
          ),
          textStyle: ThemeConstants.buttonTextStyle,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      
      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ThemeConstants.darkInput,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.inputBorderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.inputBorderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.inputBorderRadius),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.inputBorderRadius),
          borderSide: const BorderSide(color: ThemeConstants.darkError),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: TextStyle(color: ThemeConstants.darkSecondaryText),
        labelStyle: TextStyle(color: ThemeConstants.darkSecondaryText),
        errorStyle: TextStyle(color: ThemeConstants.darkError),
      ),
      
      // Dialog
      dialogTheme: DialogTheme(
        backgroundColor: ThemeConstants.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
        ),
        titleTextStyle: TextStyle(
          color: ThemeConstants.darkText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(color: ThemeConstants.darkText),
      ),
      
      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ThemeConstants.darkSurface,
        contentTextStyle: TextStyle(color: ThemeConstants.darkText),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
        ),
        behavior: SnackBarBehavior.floating,
        actionTextColor: AppColors.primaryColor,
      ),

      // Progress Indicators
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primaryColor,
        linearTrackColor: ThemeConstants.darkDivider,
      ),

      // Tooltips
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: ThemeConstants.darkSurface,
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        textStyle: TextStyle(color: ThemeConstants.darkText),
      ),
    );
  }
} 