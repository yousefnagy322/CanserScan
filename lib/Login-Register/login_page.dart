import r'package:canser_scan/Login-Register/register_page.dart';
import 'package:canser_scan/helper/show_snack_bar.dart';
import 'package:canser_scan/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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
        backgroundColor: const Color(0xFF194D59),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 250),
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
                  SizedBox(height: 24),
                  buildLabel('Email'),
                  SizedBox(height: 8),
                  buildTextField(
                    onChanged: (data) {
                      email = data;
                    },
                    screenWidth,
                    hintText: 'Enter your email',
                  ),
                  SizedBox(height: 16),
                  buildLabel('Password'),
                  SizedBox(height: 8),
                  buildTextField(
                    onChanged: (data) {
                      password = data;
                    },
                    screenWidth,
                    obscureText: true,
                    hintText: 'Enter your password',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Forget your password..?',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white70,
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      height: 45,
                      width:
                          screenWidth *
                          0.65, // Button width adjusts to screen size
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            isLoading = true;
                            setState(() {});
                            try {
                              await loginUser();
                              showSnackBar(context, 'suucess');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                showSnackBar(
                                  context,
                                  'No user found for that email.',
                                );
                              } else if (e.code == 'wrong-password') {
                                showSnackBar(
                                  context,
                                  'Wrong password provided for that user.',
                                );
                              }
                            }
                            isLoading = false;
                            setState(() {});
                          } else {}
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff3674B5),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }

  Widget buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      ),
    );
  }

  Widget buildTextField(
    double screenWidth, {
    Function(String)? onChanged,
    String? hintText,
    bool obscureText = false,
  }) {
    return SizedBox(
      width: screenWidth * 0.9,
      child: TextFormField(
        validator: (data) {
          if (data!.isEmpty) {
            return "field can't be empty";
          }
          return null;
        },
        onChanged: onChanged,
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        obscureText: obscureText,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white70,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }
}
