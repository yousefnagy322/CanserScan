import 'package:flutter/material.dart';

class BuildCustomButton extends StatelessWidget {
  const BuildCustomButton({
    super.key,
    this.onPressed,
    required this.buttonText,
  });

  final String? buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(271, 47),
        backgroundColor: const Color(0xFF3674B5),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(
        buttonText!,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
