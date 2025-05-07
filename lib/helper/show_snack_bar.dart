import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
  BuildContext context,
  String? message,
) {
  final screenWidth = MediaQuery.of(context).size.width;

  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message ?? 'No message provided',
          style: TextStyle(
            color: Colors.black87, // Matches card text color
            fontSize: screenWidth * 0.04, // Consistent with app typography
            fontWeight: FontWeight.w600, // Bold like other UI elements
          ),
        ),
      ),
      padding: EdgeInsets.all(0),
      behavior: SnackBarBehavior.floating,
      // margin: const EdgeInsets.all(16), // Floating effect like buttons
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Matches card radius
      ),
      duration: const Duration(seconds: 5),
      elevation: 4,
    ),
  );
}
