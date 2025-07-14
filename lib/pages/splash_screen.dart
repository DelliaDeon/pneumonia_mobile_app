import 'package:final_year_p/pages/nav_bar/home_page.dart';
import 'package:final_year_p/pages/intro_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 3));
    _animation = Tween<double>(begin: 0.6, end: 3,).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.repeat(reverse: true);
    Future.delayed(Duration(seconds: 6), (){
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => IntroScreen())
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset("lib/assets/images/logo_w_text.png", width: 120,),
        ),
      ),
    );
  }
}
