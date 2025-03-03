import 'package:canser_scan/Login-Register/confirm_page.dart';
import 'package:canser_scan/Login-Register/login_page.dart';
import 'package:canser_scan/Login-Register/register_page.dart';
import 'package:canser_scan/account_settings.dart';
import 'package:canser_scan/home_page.dart';
import 'package:canser_scan/test/take_test_confirm_page.dart';
import 'package:canser_scan/test/take_test_page.dart';
import 'package:canser_scan/test/test_result_neg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'welcome_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        WelcomePage.id: (context) => WelcomePage(),
        LoginPage.id: (context) => LoginPage(),
        RegisterPage.id: (context) => RegisterPage(),
        ConfirmPage.id: (context) => ConfirmPage(),
        HomePage.id: (context) => HomePage(),
        AccountSettings.id: (context) => AccountSettings(),
        TakeTestPage.id: (context) => TakeTestPage(),
        TakeTestConfirmPage.id: (context) => TakeTestConfirmPage(),
        TestResultNeg.id: (context) => TestResultNeg(),
      },
      initialRoute: WelcomePage.id,
    );
  }
}
