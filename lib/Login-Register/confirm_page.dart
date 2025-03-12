import 'package:canser_scan/Login-Register/email_verfiy.dart';
import 'package:flutter/material.dart';

class ConfirmPage extends StatelessWidget {
  const ConfirmPage({super.key});
  static String id = "ConfirmPage";
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 40,
        leadingWidth: 90,
        leading: IconButton(
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset("assets/photos/back_arrow.png"),
        ),
        backgroundColor: const Color(0xFF194D59),
      ),
      backgroundColor: const Color(0xFF194D59),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 250),
              Center(
                child: Text(
                  'Confirmation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.10,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  textAlign: TextAlign.center,
                  "A verification email has been sent to your email address.\n"
                  "Please check your inbox.\n"
                  '\n'
                  "After verification\n log in again to continue",
                  style: TextStyle(
                    height: 1.1,
                    color: Colors.white70,
                    fontSize: screenWidth * 0.052,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(height: 8),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff3674B5),
                    fixedSize: Size(screenWidth * 0.7, 45),
                  ),
                  onPressed: () async {
                    await resendVerificationEmail();
                  },
                  child: Text(
                    'Resend code',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
