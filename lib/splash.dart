import 'dart:async';
import 'package:canser_scan/home_page_v2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:canser_scan/Login-Register/login_page.dart';
import 'package:canser_scan/helper/constants.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String id = 'SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    requestPermissionsAndNavigate();
  }

  Future<void> requestPermissionsAndNavigate() async {
    await [
      Permission.camera,
      Permission.location,
      Permission.storage,
    ].request();

    // Wait for 5 seconds before navigating
    await Future.delayed(Duration(seconds: 5));

    // Check if a user is logged in
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is logged in, navigate to Home Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePageV2()),
      );
    } else {
      // User is not logged in, navigate to Login Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/photos/big_logo-removebg-preview.png',
                width: 217,
              ),
              SizedBox(height: 20),
              Text(
                'CancerScan',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Early Detection, Early Protection',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 30),
              CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
