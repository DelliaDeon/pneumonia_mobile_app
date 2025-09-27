import 'package:final_year_p/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;
  bool isDarkMode = false;

  ThemeData get themeData => _themeData;

  set themeData (ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }

  void changeTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
      isDarkMode = true;
    } else {
      themeData = lightMode;
      isDarkMode = false;
    }
  }

}