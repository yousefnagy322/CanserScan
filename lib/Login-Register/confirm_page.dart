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
                  'Enter the 8-digit confirmation code you received in the mail to confirm',
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
              TextField(
                style: TextStyle(color: Colors.white),

                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Enter code..',
                  hintStyle: TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Resend code',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white70,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff3674B5),
                    fixedSize: Size(screenWidth * 0.7, 45),
                  ),
                  onPressed: () {},
                  child: Text(
                    'confirm',
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
