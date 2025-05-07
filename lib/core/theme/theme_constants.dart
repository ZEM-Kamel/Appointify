import 'package:flutter/material.dart';

class ThemeConstants {
  // Light Theme Colors
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightAppBar = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF1A1A1A);
  static const Color lightSecondaryText = Color(0xFF666666);
  static const Color lightIcon = Color(0xFF1A1A1A);
  static const Color lightDivider = Color(0xFFE0E0E0);
  static const Color lightNavBar = Color(0xFFFFFFFF);
  static const Color lightContainer = Color(0xFFFFFFFF);
  static const Color lightButton = Color(0xFF1976D2);
  static const Color lightInput = Color(0xFFFFFFFF);
  static const Color lightError = Color(0xFFD32F2F);
  static const Color lightSuccess = Color(0xFF388E3C);
  static const Color lightWarning = Color(0xFFF57C00);
  static const Color lightInfo = Color(0xFF1976D2);
  static const Color lightDisabled = Color(0xFFBDBDBD);
  static const Color lightHover = Color(0xFFF5F5F5);
  static const Color lightFocus = Color(0xFFE3F2FD);

  // Dark Theme Colors
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkAppBar = Color(0xFF1E1E1E);
  static const Color darkText = Color(0xFFE0E0E0);
  static const Color darkSecondaryText = Color(0xFFA0A0A0);
  static const Color darkIcon = Color(0xFFE0E0E0);
  static const Color darkDivider = Color(0xFF2C2C2C);
  static const Color darkNavBar = Color(0xFF1E1E1E);
  static const Color darkContainer = Color(0xFF1E1E1E);
  static const Color darkButton = Color(0xFF1976D2);
  static const Color darkInput = Color(0xFF2C2C2C);
  static const Color darkError = Color(0xFFEF5350);
  static const Color darkSuccess = Color(0xFF66BB6A);
  static const Color darkWarning = Color(0xFFFFA726);
  static const Color darkInfo = Color(0xFF42A5F5);
  static const Color darkDisabled = Color(0xFF616161);
  static const Color darkHover = Color(0xFF2C2C2C);
  static const Color darkFocus = Color(0xFF1E3A5F);

  // Dimensions
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;
  static const double appBarElevation = 0.0;
  static const double buttonElevation = 2.0;
  static const double inputBorderRadius = 8.0;
  static const double navBarHeight = 60.0;

  // Text Styles
  static const TextStyle appBarTitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle cardTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle inputTextStyle = TextStyle(
    fontSize: 16,
  );

  // Animation Durations
  static const Duration themeTransitionDuration = Duration(milliseconds: 300);
} 