import 'package:flutter/material.dart';

class ThemeClass {
  Color lightPrimaryColor = Colors.deepOrangeAccent;
  Color darkPrimaryColor = Colors.black38;
  Color secondaryColor = Colors.deepOrangeAccent;
  Color accentColor = Colors.deepOrangeAccent;

  static ThemeData lightTheme = ThemeData(
    primaryColor: ThemeData.dark().scaffoldBackgroundColor,
    colorScheme: const ColorScheme.light().copyWith(
        primary: _themeClass.lightPrimaryColor,
        secondary: _themeClass.secondaryColor),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: ThemeData.dark().scaffoldBackgroundColor,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: _themeClass.darkPrimaryColor,
    ),
  );
}

ThemeClass _themeClass = ThemeClass();