import 'package:canser_scan/Pages/Login-Register/confirm_page.dart';
import 'package:canser_scan/Pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> sendVerificationEmail() async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null && !user.emailVerified) {
    await user.sendEmailVerification();
  }
}

Future<void> resendVerificationEmail() async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null && !user.emailVerified) {
    await user.sendEmailVerification();
  }
}

Future<bool> isEmailVerified() async {
  User? user = FirebaseAuth.instance.currentUser;
  await user?.reload(); // Refresh user data
  return user?.emailVerified ?? false;
}

void checkEmailVerification(context) async {
  bool verified = await isEmailVerified();
  if (!verified) {
    navigateToConfirm(context);
    // Redirect user to a verification screen or show a warning
  } else {
    navigateToHome(context);
  }
}

void navigateToHome(BuildContext context) {
  Navigator.pushNamed(context, HomePage.id);
}

void navigateToConfirm(BuildContext context) {
  Navigator.pushNamed(context, ConfirmPage.id);
}
