// ignore_for_file: use_build_context_synchronously, file_names, prefer_typing_uninitialized_variables, unused_local_variable

import 'package:canser_scan/helper/show_snack_bar.dart';
import 'package:canser_scan/trash/home_page_old.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> registeruser() async {
  var email;
  var password;
  UserCredential user = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: email!, password: password!);
}

Future<void> registerOnPressed(
  BuildContext context,
  GlobalKey<FormState> formKey,
  email,
  password,
) async {
  if (formKey.currentState!.validate()) {
    try {
      await registeruser();
      showSnackBar(context, 'suucess');
      Navigator.pushNamed(context, HomePageOld.id);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, 'The account already exists for that email.');
      }
    }
  } else {}
}
