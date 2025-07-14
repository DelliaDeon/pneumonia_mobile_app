import 'package:final_year_p/components/custom_button.dart';
import 'package:final_year_p/components/sign_in_up_text.dart';
import 'package:final_year_p/pages/nav_bar/custom_navbar.dart';
import 'package:flutter/material.dart';


class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // logo
              Image.asset('lib/assets/images/logo_w_text.png', width: 150,),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    // images
                    Container(
                      height: 320,
                      width: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Image.asset("lib/assets/images/2_nice_image.png"),
                    ),
                    SizedBox(height: 40,),

                    // name
                    Text('Pneumonia Checker',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Arial',
                      ),
                    ),
                    SizedBox(height: 10,),

                    // description
                    Text(
                      'Detect the presence or absence of pneumonia by simply '
                          'uploading a picture of a chest x-ray.',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 17.5,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Arial',
                      ),
                    ),
                    SizedBox(height: 30,),


                    // get started button
                    CustomButton(
                      text: 'Get Started',
                      color: Colors.blue.shade900,
                      textcolor: Colors.white,
                      onTap: (){
                        Navigator.push( context,
                          MaterialPageRoute(
                            builder: (context) => CustomBottomNavbar()
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20,),


                    // already have an account? sign in
                    SignInUpText(
                      startText: 'Already',
                      endText: 'Sign in'
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
