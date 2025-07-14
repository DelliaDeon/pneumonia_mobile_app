import 'package:final_year_p/pages/nav_bar/home_page.dart';
import 'package:final_year_p/pages/nav_bar/settings_page.dart';
import 'package:final_year_p/pages/splash_screen.dart';
import 'package:final_year_p/pages/nav_bar/storage_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import 'pages/nav_bar/info_page.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(FinalYearApp());
}

class FinalYearApp extends StatefulWidget {
  const FinalYearApp({super.key});

  @override
  State<FinalYearApp> createState() => _FinalYearAppState();
}


class _FinalYearAppState extends State<FinalYearApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

