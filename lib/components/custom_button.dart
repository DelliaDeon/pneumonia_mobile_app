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
            fontSize: 20,
            color: textcolor,
          ),
        ),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueGrey),
          color: color,
        ),
      ),
    );
  }
}
