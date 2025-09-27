import 'package:flutter/material.dart';

class MyTextfield extends StatefulWidget {
  final String text;
  final bool obscure;
  final TextEditingController controller;

  const MyTextfield({
    super.key,
    required this.text,
    required this.obscure,
    required this.controller,
  });

  @override
  State<MyTextfield> createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscure,
        decoration: InputDecoration(
          hintText: widget.text,
          hintStyle: TextStyle(
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w500
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
          ),
          fillColor: Colors.blueGrey.shade50,
        ),
      ),
    );
  }
}
