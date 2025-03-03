import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BuildTextField extends StatelessWidget {
  BuildTextField({
    super.key,
    required this.screenWidth,
    this.onChanged,
    this.hintText,
    this.obscureText = false,
  });
  final double screenWidth;
  Function(String)? onChanged;
  final String? hintText;
  bool obscureText = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth * 0.9,
      child: TextFormField(
        validator: (data) {
          if (data!.isEmpty) {
            return "Field can't be empty";
          }
          return null;
        },
        onChanged: onChanged,
        style: TextStyle(color: Colors.white),
        obscureText: obscureText,
        decoration: InputDecoration(
          errorStyle: TextStyle(
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Roboto',
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white70,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }
}
