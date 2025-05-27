import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/Pages/test/take_test_page.dart';
import 'package:canser_scan/widgets/main_custom_button.dart';
import 'package:flutter/material.dart';

class TestResultNeg extends StatelessWidget {
  const TestResultNeg({super.key});

  static String id = 'TestResultNeg';
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(color: kPrimaryColor),
          child: AppBar(
            titleSpacing: 0,
            centerTitle: true,
            title: Text(
              'Test Result',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: screenWidth * 0.08,
              ),
            ),
            scrolledUnderElevation: 0,
            toolbarHeight: 40,
            leadingWidth: 90,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset(
                'assets/photos/dark_back_arrow.png',
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 100),

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
