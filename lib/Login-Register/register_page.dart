// ignore_for_file: use_build_context_synchronously

import 'package:canser_scan/helper/show_snack_bar.dart';
import 'package:canser_scan/home_page.dart';
import 'package:canser_scan/widgets/custom_label.dart';
import 'package:canser_scan/widgets/cutom_text_filed.dart';
import 'package:canser_scan/widgets/main_custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static String id = "RegisterPage";

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  String? firstName, secondName;
  String? gender;
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
        appBar: AppBar(
          scrolledUnderElevation: 0,
          toolbarHeight: 40,
          leadingWidth: 90,
          leading: IconButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset("assets/photos/back_arrow.png"),
          ),
          backgroundColor: const Color(0xFF194D59),
        ),
        backgroundColor: const Color(0xFF194D59),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Registration",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            screenWidth * 0.10, // Adjust font size dynamically
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 46),

                  const BuildLabel(label: 'First name'),
                  BuildTextField(
                    screenWidth: screenWidth * 0.8,
                    onChanged: (data) {
                      firstName = data;
                    },
                  ),

                  const SizedBox(height: 26),
                  const BuildLabel(label: "Second name"),
                  BuildTextField(
                    screenWidth: screenWidth * 0.8,
                    onChanged: (data) {
                      secondName = data;
                    },
                  ),

                  const SizedBox(height: 26),
                  const BuildLabel(label: "Gender"),
                  const SizedBox(height: 12),
                  buildGenderOption("Male"),
                  buildGenderOption("Female"),

                  const SizedBox(height: 26),
                  const BuildLabel(label: "Email"),
                  BuildTextField(
                    onChanged: (data) {
                      email = data;
                    },
                    screenWidth: screenWidth,
                    hintText: "Enter your email or phone number..",
                  ),

                  const SizedBox(height: 26),
                  const BuildLabel(label: "Password"),
                  BuildTextField(
                    onChanged: (data) {
                      password = data;
                    },
                    screenWidth: screenWidth,
                    hintText: "Create password at least 8ch ..",
                    obscureText: true,
                  ),

                  const SizedBox(height: 36),
                  Center(
                    child: SizedBox(
                      height: 45,
                      width:
                          screenWidth *
                          0.7, // Button width adjusts to screen size
                      child: BuildCustomButton(
                        buttonText: 'Confirm',
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              await registeruser();
                              showSnackBar(context, 'suucess');
                              Navigator.pushReplacementNamed(
                                context,
                                HomePage.id,
                              );
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                showSnackBar(
                                  context,
                                  'The password provided is too weak.',
                                );
                              } else if (e.code == 'email-already-in-use') {
                                showSnackBar(
                                  context,
                                  'The account already exists for that email.',
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registeruser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);

    String uid = user.user!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'First name': firstName,
      'Second name': secondName,
      'Gender': gender,
      'Email': email,
      'Password': password,
      'uid': uid,
    });
  }

  Widget buildGenderOption(String genderValue) {
    return SizedBox(
      height: 27,
      child: Row(
        children: [
          Radio<String>(
            fillColor: WidgetStateProperty.all(Colors.white),
            activeColor: Colors.white,
            value: genderValue,
            groupValue: gender,
            onChanged: (value) {
              setState(() {
                gender = value;
              });
            },
          ),
          Text(
            genderValue,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }
}
