import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appointify_app/core/utils/app_colors.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';
  static const String _primaryColorKey = 'primary_color';
  static const String _accentColorKey = 'accent_color';
  
  ThemeMode _themeMode = ThemeMode.system;
  bool _isDarkMode = false;
  Color _primaryColor = AppColors.primaryColor;
  Color _accentColor = AppColors.secondaryColor;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _isDarkMode;
  Color get primaryColor => _primaryColor;
  Color get accentColor => _accentColor;

  ThemeProvider() {
    _loadThemePreferences();
  }

  Future<void> _loadThemePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load theme mode
      final savedThemeMode = prefs.getString(_themeModeKey);
      if (savedThemeMode != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == savedThemeMode,
          orElse: () => ThemeMode.system,
        );
      }

      // Load primary color
      final savedPrimaryColor = prefs.getInt(_primaryColorKey);
      if (savedPrimaryColor != null) {
        _primaryColor = Color(savedPrimaryColor);
      }

      // Load accent color
      final savedAccentColor = prefs.getInt(_accentColorKey);
      if (savedAccentColor != null) {
        _accentColor = Color(savedAccentColor);
      }

      _updateDarkMode();
      notifyListeners();
    } catch (e) {
      // Handle error gracefully
      _themeMode = ThemeMode.system;
      _primaryColor = AppColors.primaryColor;
      _accentColor = AppColors.secondaryColor;
      _updateDarkMode();
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    _updateDarkMode();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, mode.toString());
    } catch (e) {
      // Handle error gracefully
    }

    notifyListeners();
  }

  Future<void> setPrimaryColor(Color color) async {
    if (_primaryColor == color) return;

    _primaryColor = color;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_primaryColorKey, color.value);
    } catch (e) {
      // Handle error gracefully
    }

    notifyListeners();
  }

  Future<void> setAccentColor(Color color) async {
    if (_accentColor == color) return;

    _accentColor = color;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_accentColorKey, color.value);
    } catch (e) {
      // Handle error gracefully
    }

    notifyListeners();
  }

  Future<void> resetThemePreferences() async {
    _themeMode = ThemeMode.system;
    _primaryColor = AppColors.primaryColor;
    _accentColor = AppColors.secondaryColor;
    _updateDarkMode();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_themeModeKey);
      await prefs.remove(_primaryColorKey);
      await prefs.remove(_accentColorKey);
    } catch (e) {
      // Handle error gracefully
    }

    notifyListeners();
  }

  void updateSystemTheme(Brightness brightness) {
    if (_themeMode == ThemeMode.system) {
      _isDarkMode = brightness == Brightness.dark;
      notifyListeners();
    }
  }

  void _updateDarkMode() {
    switch (_themeMode) {
      case ThemeMode.light:
        _isDarkMode = false;
        break;
      case ThemeMode.dark:
        _isDarkMode = true;
        break;
      case ThemeMode.system:
        _isDarkMode = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
        break;
    }
  }
} 