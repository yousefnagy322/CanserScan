import 'package:flutter/material.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});
  static String id = "AccountSettings";
  @override
  AccountSettingsState createState() => AccountSettingsState();
}

class AccountSettingsState extends State<AccountSettings> {
  String? gender;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff56EACF),
                Color(0xff194D59),
              ], // Change colors as needed
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            scrolledUnderElevation: 0,
            toolbarHeight: 40,
            leadingWidth: 90,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset('assets/photos/dark_back_arrow.png'),
            ),
          ),
        ),
      ),

      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              Center(
                child: Text(
                  'Your Account',
                  style: TextStyle(
                    color: Color(0xff194D59),
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 32),
              buildLabel('First Name'),
              buildTextField(screenWidth, hintText: 'Yousef'),
              SizedBox(height: 26),
              buildLabel('Last Name'),
              buildTextField(screenWidth, hintText: 'Nagy'),
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
              buildTextField(screenWidth),
              SizedBox(height: 26),
              buildLabel('Password'),
              buildTextField(screenWidth, obscureText: true),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
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
    );
  }

  Widget buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Color(0xff194D59),
        fontSize: 18,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      ),
    );
  }

  Widget buildTextField(
    double screenWidth, {
    String? hintText,
    bool obscureText = false,
  }) {
    return SizedBox(
      height: screenWidth * 0.08,
      width: screenWidth * 0.9,
      child: TextField(
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
            fillColor: WidgetStateProperty.all(Color(0xff194D59)),
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
