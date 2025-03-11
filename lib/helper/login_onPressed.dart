// ignore_for_file: use_build_context_synchronously

import 'package:canser_scan/helper/show_snack_bar.dart';
import 'package:canser_scan/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> loginOnPressed(
  BuildContext context,
  GlobalKey<FormState> formKey,
  email,
  password,
) async {
  if (formKey.currentState!.validate()) {
    try {
      await loginUser(email, password);
      showSnackBar(context, 'suucess');
      Navigator.pushNamed(context, HomePage.id);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, 'Wrong password provided for that user.');
      }
    }
  } else {}
}

Future<void> loginUser(email, password) async {
  // ignore: unused_local_variable
  UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email!,
    password: password!,
  );
}
