import 'package:canser_scan/Login-Register/confirm_page.dart';
import 'package:canser_scan/Login-Register/login_page.dart';
import 'package:canser_scan/test/take_test_confirm_page.dart';
import 'package:canser_scan/test/test_result_neg.dart';
import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  static String id = "WelcomePage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF194D59),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.only(right: 150),
              child: SimpleShadow(
                child: Image.asset(
                  'assets/photos/welcome_small.png',
                  height: 50,
                  width: 50,
                ),
              ),
            ),
            SimpleShadow(
              offset: const Offset(0, 4),
              opacity: 0.5,
              color: Colors.black,
              child: Image.asset(
                'assets/photos/Welcome_big.png',
                height: 215,
                width: 311,
              ),
            ),
            const SizedBox(height: 73.5),
            const Text(
              'Welcome',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Roboto',
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'to',
              style: TextStyle(
                color: Colors.white54,
                fontFamily: 'Roboto',
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Text(
              'CanserScan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 44),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, LoginPage.id);
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(271, 45),
                backgroundColor: const Color(0xFF3674B5),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Get Started",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConfirmPage()),
                );
              },
              child: Text('confirm screen'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TakeTestConfirmPage(),
                  ),
                );
              },
              child: Text('confirm screen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TestResultNeg()),
                );
              },
              child: Text('test neg screen'),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
