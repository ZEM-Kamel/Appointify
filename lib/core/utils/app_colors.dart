import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary Colors
  static const Color primaryColor = Color(0xFF1976D2);       // Blue
  static const Color primaryLight = Color(0xFF63A4FF);       // Lighter Blue
  static const Color primaryDark = Color(0xFF004BA0);        // Darker Blue
  
  // Secondary Colors
  static const Color secondaryColor = Color(0xFF4CAF50);     // Green
  static const Color secondaryLight = Color(0xFF80E27E);     // Lighter Green
  static const Color secondaryDark = Color(0xFF087F23);      // Darker Green
  
  // Accent Colors
  static const Color accentColor = Color(0xFFE0E0E0);        // Light Grey
  static const Color accentLight = Color(0xFFF5F5F5);        // Lighter Grey
  static const Color accentDark = Color(0xFFBDBDBD);         // Darker Grey
  
  // Status Colors
  static const Color successColor = Color(0xFF388E3C);       // Success Green
  static const Color warningColor = Color(0xFFF57C00);       // Warning Orange
  static const Color errorColor = Color(0xFFD32F2F);         // Error Red
  static const Color infoColor = Color(0xFF1976D2);          // Info Blue
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);        // Primary Text
  static const Color textSecondary = Color(0xFF666666);      // Secondary Text
  static const Color textHint = Color(0xFF9E9E9E);           // Hint Text
  static const Color textDisabled = Color(0xFFBDBDBD);       // Disabled Text
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFF5F5F5);    // Light Background
  static const Color backgroundDark = Color(0xFF121212);     // Dark Background
  static const Color surfaceLight = Color(0xFFFFFFFF);       // Light Surface
  static const Color surfaceDark = Color(0xFF1E1E1E);        // Dark Surface
  
  // Border Colors
  static const Color borderLight = Color(0xFFE0E0E0);        // Light Border
  static const Color borderDark = Color(0xFF2C2C2C);         // Dark Border
  
  // Overlay Colors
  static const Color overlayLight = Color(0x0A000000);       // Light Overlay
  static const Color overlayDark = Color(0x0AFFFFFF);        // Dark Overlay
}
