import 'package:canser_scan/Pages/chatbot_page.dart';
import 'package:canser_scan/Pages/Login-Register/confirm_page.dart';
import 'package:canser_scan/Pages/Login-Register/forgot_password_page.dart';
import 'package:canser_scan/Pages/Login-Register/login_page.dart';
import 'package:canser_scan/Pages/Login-Register/register_page.dart';
import 'package:canser_scan/Pages/about_us_page.dart';
import 'package:canser_scan/Pages/Drawer/account_settings_page.dart';
import 'package:canser_scan/Pages/Drawer/app_language_page.dart';
import 'package:canser_scan/Pages/Doctors/doctors_page.dart';
import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/Pages/history_page.dart';
import 'package:canser_scan/trash/home_page_old.dart';
import 'package:canser_scan/Pages/home_page.dart';
import 'package:canser_scan/Pages/info_pages/actinic_keratosis.dart';
import 'package:canser_scan/Pages/info_pages/basal_cell_carcinoma.dart';
import 'package:canser_scan/Pages/info_pages/benign_keratosis.dart';
import 'package:canser_scan/Pages/info_pages/dermatofibroma.dart';
import 'package:canser_scan/Pages/info_pages/information_page.dart';
import 'package:canser_scan/Pages/info_pages/melanocytic_nevus.dart';
import 'package:canser_scan/Pages/info_pages/melanoma.dart';
import 'package:canser_scan/Pages/info_pages/skin_cancer.dart';
import 'package:canser_scan/Pages/info_pages/vascular_lesion.dart';
import 'package:canser_scan/Pages/map_page.dart';
import 'package:canser_scan/provider/navigation_provider.dart';
import 'package:canser_scan/splash.dart';
import 'package:canser_scan/Pages/test/take_test_confirm_page.dart';
import 'package:canser_scan/Pages/test/take_test_page.dart';
import 'package:canser_scan/Pages/test/test_result_neg.dart';
import 'package:canser_scan/Pages/test/test_result_pos.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'core/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Lock screen orientation to portrait mode
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

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
          LoginPage.id: (context) => LoginPage(),
          RegisterPage.id: (context) => RegisterPage(),
          ConfirmPage.id: (context) => ConfirmPage(),
          HomePageOld.id: (context) => HomePageOld(),
          HomePage.id: (context) => HomePage(),
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
          ForgotPasswordPage.id: (context) => ForgotPasswordPage(),
          AboutUsPage.id: (context) => const AboutUsPage(),
          AppLanguagePage.id: (context) => const AppLanguagePage(),
        },
        initialRoute: SplashScreen.id,
      ),
    );
  }
}
