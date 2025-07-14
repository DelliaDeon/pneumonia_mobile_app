import 'package:flutter/material.dart';

class CustomIconSizeButton extends StatelessWidget {
  final Color color;
  final String text;
  final IconData icon;
  final double height;
  final double width;
  final Color textcolor;
  Function()? onTap;

  CustomIconSizeButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.height,
    required this.width,
    required this.onTap,
    required this.textcolor,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Icon(icon, color: textcolor, size: 32,),
              Text(text, style: TextStyle(
                color: textcolor,
                fontSize: 17.5,
                fontWeight: FontWeight.w400,
              ),),
            ],
          ),
        ),
        height: height,
        width: width,
      ),
    );
  }
}
