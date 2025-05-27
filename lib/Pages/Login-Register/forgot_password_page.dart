// ignore_for_file: use_build_context_synchronously

import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/helper/show_snack_bar.dart';
import 'package:canser_scan/widgets/custom_label.dart';
import 'package:canser_scan/widgets/cutom_text_filed.dart';
import 'package:canser_scan/widgets/main_custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  static String id = "ForgotPasswordPage";

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String? email;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      color: Colors.white70,
      progressIndicator: const CircularProgressIndicator(color: Colors.white),
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
                      'Reset Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.10,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const BuildLabel(label: 'Email'),
                  const SizedBox(height: 8),
                  BuildTextField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (data) {
                      email = data;
                    },
                    screenWidth: screenWidth,
                    hintText: 'Enter your email',
                    // Removed keyboardType parameter to match your existing widget
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      width: screenWidth * 0.65,
                      child: BuildCustomButton(
                        color: ksecondarycolor,
                        buttonText: 'Send Reset Link',
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              await resetPassword();
                              showSnackBar(
                                context,
                                'Password reset email sent successfully. Check your inbox.',
                              );
                              Navigator.pop(context);
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                showSnackBar(
                                  context,
                                  'No user found with this email.',
                                );
                              } else if (e.code == 'invalid-email') {
                                showSnackBar(context, 'Invalid email format.');
                              } else {
                                showSnackBar(
                                  context,
                                  'An error occurred. Please try again.',
                                );
                              }
                            }
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Back to Login',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> resetPassword() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email!);
  }
}
