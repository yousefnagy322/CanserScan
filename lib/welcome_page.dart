import 'package:canser_scan/Login-Register/confirm_page.dart';
import 'package:canser_scan/Login-Register/login_page.dart';
import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/test/take_test_confirm_page.dart';
import 'package:canser_scan/widgets/main_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  static String id = "WelcomePage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 1),

            SimpleShadow(
              offset: const Offset(0, 4),
              opacity: 0.5,
              color: Colors.white54,
              child: Image.asset(
                'assets/photos/big_logo-removebg-preview.png',
                height: 250,
                width: 311,
              ),
            ),
            const SizedBox(height: 60),
            const Text(
              'Welcome',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Roboto',
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Text(
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
            BuildCustomButton(
              buttonText: 'Get Started',
              onPressed: () {
                Navigator.pushReplacementNamed(context, LoginPage.id);
              },
            ),

            //will be removed
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
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
