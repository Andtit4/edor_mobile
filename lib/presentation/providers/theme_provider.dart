import 'package:edor/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_provider.dart';

// Theme Mode State
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences _prefs;
  static const String _key = 'theme_mode';

  ThemeModeNotifier(this._prefs) : super(ThemeMode.system) {
    _loadThemeMode();
  }

  void _loadThemeMode() {
    final savedThemeMode = _prefs.getString(_key);
    if (savedThemeMode != null) {
      switch (savedThemeMode) {
        case 'light':
          state = ThemeMode.light;
          break;
        case 'dark':
          state = ThemeMode.dark;
          break;
        case 'system':
        default:
          state = ThemeMode.system;
          break;
      }
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = themeMode;
    String themeModeString;
    switch (themeMode) {
      case ThemeMode.light:
        themeModeString = 'light';
        break;
      case ThemeMode.dark:
        themeModeString = 'dark';
        break;
      case ThemeMode.system:
        themeModeString = 'system';
        break;
    }
    await _prefs.setString(_key, themeModeString);
  }

  void toggleTheme() {
    final newThemeMode =
        state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    setThemeMode(newThemeMode);
  }
}

// Theme Provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeModeNotifier(prefs);
});

// Is Dark Mode Provider
final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeModeProvider);

  if (themeMode == ThemeMode.system) {
    // Pour le MVP, on suppose que le système est en mode clair
    // Dans une vraie app, on utiliserait MediaQuery.platformBrightnessOf(context)
    return false;
  }

  return themeMode == ThemeMode.dark;
});
