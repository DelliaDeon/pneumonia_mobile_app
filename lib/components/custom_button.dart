import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  String text;
  Color color;
  Color textcolor;
  Function()? onTap;

  CustomButton({
    super.key,
    required this.text,
    required this.color,
    required this.textcolor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textcolor,
          ),
        ),

        margin: EdgeInsets.all(15),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 75),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.blue),
          color: color,
        ),
      ),
    );
  }
}
