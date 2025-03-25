// ignore_for_file: use_build_context_synchronously

import 'package:canser_scan/Login-Register/email_verfiy.dart';
import r'package:canser_scan/Login-Register/register_page.dart';
import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/helper/show_snack_bar.dart';
import 'package:canser_scan/map_page.dart';
import 'package:canser_scan/splash.dart';
import 'package:canser_scan/widgets/custom_label.dart';
import 'package:canser_scan/widgets/cutom_text_filed.dart';
import 'package:canser_scan/widgets/main_custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String id = "LoginPage";
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;
  String? password;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      color: Colors.white70,
      progressIndicator: CircularProgressIndicator(color: Colors.white),
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 250),
                  Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            screenWidth * 0.10, // Adjust font size dynamically
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const BuildLabel(label: 'Email'),
                  const SizedBox(height: 8),
                  BuildTextField(
                    onChanged: (data) {
                      email = data;
                    },
                    screenWidth: screenWidth,
                    hintText: 'Enter your email',
                  ),
                  const SizedBox(height: 16),
                  const BuildLabel(label: 'Password'),
                  const SizedBox(height: 8),
                  BuildTextField(
                    onChanged: (data) {
                      password = data;
                    },
                    screenWidth: screenWidth,
                    obscureText: true,
                    hintText: 'Enter your password',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Forget your password..?',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white70,
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      width:
                          screenWidth *
                          0.65, // Button width adjusts to screen size
                      child: BuildCustomButton(
                        color: ksecondarycolor,
                        buttonText: 'Login',
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              FocusManager.instance.primaryFocus?.unfocus();
                              await loginUser(email, password);
                              await isEmailVerified();
                              checkEmailVerification(context);
                            } on FirebaseAuthException catch (e) {
                              print(e.code);
                              if (e.code == 'invalid-credential') {
                                showSnackBar(
                                  context,
                                  'Invalid email or password.',
                                );
                              } else if (e.code == 'wrong-password') {
                                showSnackBar(
                                  context,
                                  'Wrong password provided for that user.',
                                );
                              }
                            }
                            setState(() {
                              isLoading = false;
                            });
                          } else {}
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RegisterPage.id);
                      },
                      child: Text(
                        'Don\'t Have Account.?',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white70,
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),

                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.pushNamed(context, SplashScreen.id);
                  //   },
                  //   child: Text('data'),
                  // ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.pushNamed(context, MapPage.id);
                  //   },
                  //   child: Text('map'),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser(email, password) async {
    // ignore: unused_local_variable
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
