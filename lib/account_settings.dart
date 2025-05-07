// ignore_for_file: use_build_context_synchronously

import 'package:canser_scan/Login-Register/login_page.dart';
import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/helper/get_user_build.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});
  static String id = "AccountSettings";
  @override
  AccountSettingsState createState() => AccountSettingsState();
}

class AccountSettingsState extends State<AccountSettings> {
  String? gender;
  String? storedGender;
  String? newfirstname, newsecoundname, newemail, newpassword;
  bool hidePassword = true;
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    fetchGenderFromDatabase(); // Fetch data when widget initializes
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(color: kPrimaryColor),
          child: AppBar(
            centerTitle: true,
            title: Text(
              'Settings',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: screenWidth * 0.08,
              ),
            ),
            scrolledUnderElevation: 0,
            toolbarHeight: 40,
            leadingWidth: 90,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset(
                'assets/photos/dark_back_arrow.png',
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80),
                  Center(
                    child: Text(
                      'Your Account',
                      style: TextStyle(
                        color: Color(0xff194D59),
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  buildLabel('First Name'),
                  FutureBuilder<String>(
                    future: getUserData('First name'),
                    builder: (context, snapshot) {
                      return buildTextField(
                        screenWidth,
                        hintText: snapshot.data,
                        onchanged: (value) => newfirstname = value,
                      );
                    },
                  ),
                  SizedBox(height: 26),
                  buildLabel('Last Name'),
                  FutureBuilder(
                    future: getUserData("Second name"),
                    builder: (builder, snapshot) {
                      return buildTextField(
                        screenWidth,
                        hintText: snapshot.data,
                        onchanged: (value) => newsecoundname = value,
                      );
                    },
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Gender',
                    style: TextStyle(
                      color: Color(0xff194D59),
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  buildGenderOption('Male'),
                  buildGenderOption('Female'),
                  SizedBox(height: 26),
                  buildLabel('Email'),
                  FutureBuilder(
                    future: getUserData('Email'),
                    builder:
                        (context, snapshot) => buildTextField(
                          readonly: true,
                          screenWidth,
                          hintText: snapshot.data,
                          onchanged: (value) => newemail = value,
                        ),
                  ),
                  SizedBox(height: 26),
                  buildLabel('Password'),
                  Stack(
                    children: [
                      FutureBuilder(
                        future: getUserData('Password'),
                        builder: (context, snapshot) {
                          return buildTextField(
                            screenWidth,
                            hintText:
                                hidePassword ? '**********' : snapshot.data,
                            onchanged: (value) => newpassword = value,
                            obscureText: hidePassword,
                          );
                        },
                      ),
                      Positioned(
                        top: -10,
                        right: 0,
                        child: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: kPrimaryColor,
                          ),
                          onPressed: () {
                            hidePassword = !hidePassword;
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        updateUserData();
                        Navigator.pushReplacementNamed(context, LoginPage.id);
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(screenWidth * 0.6, 45),
                        backgroundColor: Color(0xff194D59),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'Change',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
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

  void updateUserData() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      String userId = FirebaseAuth.instance.currentUser!.uid;

      try {
        // Fetch current user data
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .get();
        Map<String, dynamic> currentData =
            userDoc.data() as Map<String, dynamic>;

        // Use old values if new ones are null
        String updatedFirstName =
            newfirstname?.isNotEmpty == true
                ? newfirstname!
                : currentData['First name'];
        String updatedSecondName =
            newsecoundname?.isNotEmpty == true
                ? newsecoundname!
                : currentData['Second name'];
        String updatedEmail =
            newemail?.isNotEmpty == true ? newemail! : currentData['Email'];
        String updatedPassword =
            newpassword?.isNotEmpty == true
                ? newpassword!
                : currentData['Password'];
        String updatedGender =
            gender?.isNotEmpty == true ? gender! : currentData['Gender'];

        // Update Firestore with new (or old) values
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'First name': updatedFirstName,
          'Second name': updatedSecondName,
          'Email': updatedEmail,
          'Password':
              updatedPassword, // ⚠️ Storing passwords in Firestore is **not** secure
          'Gender': updatedGender,
        });

        // Update Firebase Authentication email (only if changed)
        if (newemail?.isNotEmpty == true) {
          await FirebaseAuth.instance.currentUser!.verifyBeforeUpdateEmail(
            updatedEmail,
          );
        }

        // Update Firebase Authentication password (only if changed)
        if (newpassword?.isNotEmpty == true) {
          await FirebaseAuth.instance.currentUser!.updatePassword(
            updatedPassword,
          );
        }
      } catch (e) {
        print('Error updating user data: $e');
      }
    }
  }

  void fetchGenderFromDatabase() async {
    String? storedGender = await getUserData('Gender'); // Fetch data

    if (mounted) {
      setState(() {
        gender = storedGender; // Ensure null safety
      });
    }
  }

  Widget buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: kPrimaryColor,
        fontSize: 18,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      ),
    );
  }

  Widget buildTextField(
    double screenWidth, {
    dynamic onchanged,
    String? hintText,
    bool readonly = false,
    bool obscureText = false,
  }) {
    return SizedBox(
      height: screenWidth * 0.08,
      width: screenWidth * 0.9,
      child: TextFormField(
        readOnly: readonly,
        onChanged: onchanged,
        style: TextStyle(color: Color(0xCC000000)),
        cursorColor: Color(0xCC000000),
        obscureText: obscureText,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffB0A7A7), width: 1),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            height: 1.5,
            color: Color(0xCC000000),
            fontSize: 16,
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
            fillColor: WidgetStateProperty.all(Color(0xff194D59)),
            activeColor: Colors.white,
            value: genderValue,
            groupValue: gender,
            onChanged: (value) {
              setState(() {
                gender = value;
                storedGender = value;
              });
            },
          ),
          Text(
            genderValue,
            style: TextStyle(
              color: Color(0xff194D59),
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
