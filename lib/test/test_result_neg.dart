import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/test/take_test_page.dart';
import 'package:canser_scan/widgets/main_custom_button.dart';
import 'package:flutter/material.dart';

class TestResultNeg extends StatelessWidget {
  const TestResultNeg({super.key});

  static String id = 'TestResultNeg';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff56EACF),
                Color(0xff194D59),
              ], // Change colors as needed
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            scrolledUnderElevation: 0,
            toolbarHeight: 40,
            leadingWidth: 90,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset('assets/photos/dark_back_arrow.png'),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 100),
            Text(
              'Test Result',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Negative',
              style: TextStyle(
                color: Colors.green,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 60),
            BuildCustomButton(
              color: kPrimaryColor,
              buttonText: 'Another test',
              onPressed: () {
                Navigator.pushReplacementNamed(context, TakeTestPage.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
