import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/colors.dart';

// primary swatch for light theme
Map<int, Color> colorLight = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

// light theme
ThemeData light = ThemeData(
  appBarTheme: AppBarTheme(color: lightAppBarColor),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: MaterialColor(0xFF002FA7, colorLight)).copyWith(
    secondary: lightAccentColor,
    brightness: Brightness.light,
  ),
);

// dark theme
ThemeData dark = ThemeData(
  appBarTheme: AppBarTheme(color: Colors.black45, foregroundColor: colorWhite),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: MaterialColor(0xFF2FBE43, colorLight)).copyWith(
    secondary: darkAccentColor,
    brightness: Brightness.dark,
  ),
);

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences _preferences;
  bool _isDark;

// getter
  bool get isDark => _isDark;

  ThemeNotifier() {
    _isDark = true; // default value
    _loadFromPrefs();
  }

// function to change the theme
  toggleTheme() {
    _isDark = !_isDark;
    _savedToPrefs();
    notifyListeners();
  }

// initiating SharedPreferences
  _initPrefs() async {
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
  }

// loading saved preferences
  _loadFromPrefs() async {
    await _initPrefs();
    _isDark = _preferences.getBool(key) ?? true;
    notifyListeners();
  }

// saving to preferences
  _savedToPrefs() async {
    await _initPrefs();
    _preferences.setBool(key, _isDark);
  }
}
