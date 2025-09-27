import 'package:final_year_p/pages/nav_bar/home_page.dart';
import 'package:final_year_p/pages/nav_bar/info_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class CustomBottomNavbar extends StatefulWidget {
  const CustomBottomNavbar({super.key});

  @override
  State<CustomBottomNavbar> createState() => _CustomBottomNavbarState();
}

class _CustomBottomNavbarState extends State<CustomBottomNavbar> {
  PersistentTabController _controller = PersistentTabController();

  List<Widget> _buildScreens() {
    return [
      HomePage(),
      InfoPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarItems(),
      navBarHeight: 65,
      navBarStyle: NavBarStyle.style10,
      backgroundColor: Colors.blue.shade900,
      padding: EdgeInsets.all(5),
      isVisible: true,
      resizeToAvoidBottomInset: true,
      confineToSafeArea: true,
      animationSettings: NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          animateTabTransition: true,
          duration: Duration(milliseconds: 300),
          screenTransitionAnimationType: ScreenTransitionAnimationType.slide,
        ),
      ),
    );
  }
}


List<PersistentBottomNavBarItem> _navBarItems() {
  return[
    PersistentBottomNavBarItem(
      icon: Icon(CupertinoIcons.home),
      contentPadding: 5.0,
      title: 'Home',
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      activeColorPrimary: Colors.blue.shade800,
      activeColorSecondary: Colors.white,
      inactiveColorPrimary: Colors.lightBlueAccent,
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/': (context) => HomePage(),
            '/info': (context) =>InfoPage(),
          }
      ),
    ),

    PersistentBottomNavBarItem(
      icon: Icon(CupertinoIcons.book),
      title: 'Research',
      contentPadding: 5.0,
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      activeColorPrimary: Colors.blue.shade800,
      activeColorSecondary: Colors.white,
      inactiveColorPrimary: Colors.lightBlueAccent,
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/': (context) => HomePage(),
            '/info': (context) =>InfoPage(),
          }
      ),
    ),

  ];
}


