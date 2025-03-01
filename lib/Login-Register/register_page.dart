import 'package:canser_scan/helper/show_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  String? gender; // To store selected gender
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
                  SizedBox(height: 46),

                  buildLabel("First name"),
                  buildTextField(screenWidth * 0.8),

                  SizedBox(height: 26),
                  buildLabel("Second name"),
                  buildTextField(screenWidth * 0.8),

                  SizedBox(height: 26),
                  buildLabel("Gender"),
                  SizedBox(height: 12),
                  buildGenderOption("Male"),
                  buildGenderOption("Female"),

                  SizedBox(height: 26),
                  buildLabel("Email"),
                  buildTextField(
                    onChanged: (data) {
                      email = data;
                    },
                    screenWidth,
                    hintText: "Enter your email or phone number..",
                  ),

                  SizedBox(height: 26),
                  buildLabel("Password"),
                  buildTextField(
                    onChanged: (data) {
                      password = data;
                    },
                    screenWidth,
                    hintText: "Create password at least 8ch ..",
                    obscureText: true,
                  ),

                  SizedBox(height: 36),
                  Center(
                    child: SizedBox(
                      height: 45,
                      width:
                          screenWidth *
                          0.7, // Button width adjusts to screen size
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            isLoading = true;
                            setState(() {});
                            try {
                              await registeruser();
                              showSnackBar(context, 'suucess');
                              Navigator.pop(context);
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
                          "Confirm",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
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
