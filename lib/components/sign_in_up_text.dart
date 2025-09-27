import 'package:flutter/material.dart';

class SignInUpText extends StatefulWidget {
  final String startText;
  final String endText;
  Function()? onTap;

  SignInUpText({
    super.key,
    required this.startText,
    required this.endText,
    required this.onTap,
  });

  @override
  State<SignInUpText> createState() => _SignInUpTextState();
}

class _SignInUpTextState extends State<SignInUpText> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${widget.startText} have an account?  ",
          style: TextStyle(
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w500,
            fontSize: 16
          ),
        ),

        GestureDetector(
          onTap: widget.onTap,
          child: Text(
            widget.endText,
            style: TextStyle(
              color: Colors.blue.shade900,
                fontWeight: FontWeight.w500,
                fontSize: 16
            ),
          ),
        ),
      ],
    );
  }
}
