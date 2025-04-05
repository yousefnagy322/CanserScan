import 'package:canser_scan/Chatbot/chat_page.dart';
import 'package:canser_scan/Login-Register/confirm_page.dart';
import 'package:canser_scan/Login-Register/forgot_password_page.dart';
import 'package:canser_scan/Login-Register/login_page.dart';
import 'package:canser_scan/Login-Register/register_page.dart';
import 'package:canser_scan/about_us_page.dart';
import 'package:canser_scan/account_settings.dart';
import 'package:canser_scan/add_doctor_page.dart';
import 'package:canser_scan/doctors_page.dart';
import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/history_page.dart';
import 'package:canser_scan/home_page.dart';
import 'package:canser_scan/home_page_v2.dart';
import 'package:canser_scan/info_pages/actinic_keratosis.dart';
import 'package:canser_scan/info_pages/basal_cell_carcinoma.dart';
import 'package:canser_scan/info_pages/benign_keratosis.dart';
import 'package:canser_scan/info_pages/dermatofibroma.dart';
import 'package:canser_scan/info_pages/information_page.dart';
import 'package:canser_scan/info_pages/melanocytic_nevus.dart';
import 'package:canser_scan/info_pages/melanoma.dart';
import 'package:canser_scan/info_pages/skin_cancer.dart';
import 'package:canser_scan/info_pages/vascular_lesion.dart';
import 'package:canser_scan/map_page.dart';

import 'package:canser_scan/navigation_provider.dart';
import 'package:canser_scan/splash.dart';
import 'package:canser_scan/test/take_test_confirm_page.dart';
import 'package:canser_scan/test/take_test_page.dart';
import 'package:canser_scan/test/test_result_neg.dart';
import 'package:canser_scan/test/test_result_pos.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'welcome_page.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Lock screen orientation to portrait mode
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => NavigationProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: const Color(0xFF26A69A),
            selectionColor: const Color(0xFF7AC5C9),
            selectionHandleColor: const Color(0xFF26A69A),
          ),
        ),
        routes: {
          WelcomePage.id: (context) => WelcomePage(),
          LoginPage.id: (context) => LoginPage(),
          RegisterPage.id: (context) => RegisterPage(),
          ConfirmPage.id: (context) => ConfirmPage(),
          HomePage.id: (context) => HomePage(),
          HomePageV2.id: (context) => HomePageV2(),
          AccountSettings.id: (context) => AccountSettings(),
          TakeTestPage.id: (context) => TakeTestPage(),
          TakeTestConfirmPage.id: (context) => TakeTestConfirmPage(),
          TestResultNeg.id: (context) => TestResultNeg(),
          TestResultPos.id: (context) => TestResultPos(),
          InformationPage.id: (context) => InformationPage(),
          SkinCancer.id: (context) => SkinCancer(),
          BenignKeratosis.id: (context) => BenignKeratosis(),
          VascularLesion.id: (context) => VascularLesion(),
          Melanoma.id: (context) => Melanoma(),
          MelanocyticNevus.id: (context) => MelanocyticNevus(),
          Dermatofibroma.id: (context) => Dermatofibroma(),
          ActinicKeratosis.id: (context) => ActinicKeratosis(),
          BasalCellCarcinoma.id: (context) => BasalCellCarcinoma(),
          ChatPage.id: (context) => ChatPage(),
          SplashScreen.id: (context) => SplashScreen(),
          DoctorsPage.id: (context) => DoctorsPage(),
          MapPage.id: (context) => MapPage(),
          HistoryPage.id: (context) => HistoryPage(),
          AddDoctorPage.id: (context) => AddDoctorPage(),
          ForgotPasswordPage.id: (context) => ForgotPasswordPage(),
          AboutUsPage.id: (context) => const AboutUsPage(),
        },
        initialRoute: SplashScreen.id,
      ),
    );
  }
}
