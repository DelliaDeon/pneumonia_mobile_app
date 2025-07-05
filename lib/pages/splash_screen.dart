import 'package:final_year_p/pages/home_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: Column(
                children: [
                  // logo

                  // image
                  Image.asset("lib/assets/images/1_image.jpeg"),

                  // text
                  Text(
                    'Upload A Picture Of Your Chest X-ray '
                    'To Detect The Presence or Absence of Pneumonia!',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Arial',
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 20,),

                  // get started button
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage()
                        ),
                      );
                    },
                    child: Container(
                      child: Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blue.shade600,
                    ),
                  ),
                )
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}
