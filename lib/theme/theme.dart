
import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  scaffoldBackgroundColor: Colors.blueGrey.shade50,
  colorScheme: ColorScheme.light(
    brightness: Brightness.light,
    primary: Colors.blue.shade900,
    secondary: Colors.grey.shade800,
    tertiary: Colors.blue.shade800,
    surface: Colors.black,
    inversePrimary: Colors.blueGrey.shade800,
    secondaryContainer: Colors.white,
  )
);

ThemeData darkMode = ThemeData(
  scaffoldBackgroundColor: Colors.black,
    colorScheme: ColorScheme.light(
      brightness: Brightness.dark,
      primary: Colors.blue.shade900,
      secondary: Colors.blueGrey.shade50,
      tertiary: Colors.blue.shade800,
      surface: Colors.white,
      inversePrimary: Colors.blueGrey.shade800,
      secondaryContainer: Colors.grey.shade900,
    )
);