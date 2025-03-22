import 'package:canser_scan/Chatbot/chat_page.dart';
import 'package:canser_scan/Login-Register/login_page.dart';
import 'package:canser_scan/account_settings.dart';
import 'package:canser_scan/doctors_page.dart';
import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/history_page.dart';
import 'package:canser_scan/info_pages/information_page.dart';
import 'package:canser_scan/map_page.dart';
import 'package:canser_scan/test/take_test_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:intl/intl.dart';

class HomePageV2 extends StatefulWidget {
  const HomePageV2({super.key});
  static String id = "HomePageV2";

  @override
  State<HomePageV2> createState() => _HomePageV2State();
}

class _HomePageV2State extends State<HomePageV2> {
  @override
  initState() {
    super.initState();
    fetchLatestTestResult();
  }

  String? result;
  String? prediction = "No Cancer";
  double? confidence;
  Timestamp? timestamp;
  String? formattedDate;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      drawer: Drawer(
        backgroundColor: const Color(0xffFFFFFF),
        width: screenWidth * 0.5,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 58),
              height: 180,
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Image.asset(
                    'assets/photos/drawer_person.png',
                    height: screenWidth * 0.1,
                    width: screenWidth * 0.1,
                  ),
                  buildUserData(
                    filed: 'First name',
                    color: Colors.black,
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
            builddrawercategory(
              screenWidth,
              'settings',
              'assets/photos/settings.png',
              ontap: () {
                Navigator.pushNamed(context, AccountSettings.id);
              },
            ),
            builddrawercategory(
              screenWidth,
              'Language',
              'assets/photos/language.png',
            ),
            builddrawercategory(
              screenWidth,
              'Log Out',
              'assets/photos/logout.png',
              ontap: () {
                Navigator.pushReplacementNamed(context, LoginPage.id);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          SimpleShadow(
            offset: const Offset(0, 4),
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              height: 56,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color(0xffD9D9D9),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NavBarElement(
                    image: 'assets/photos/navbartest.png',
                    text: 'Test',
                    ontap: () {
                      Navigator.pushNamed(context, TakeTestPage.id);
                    },
                  ),
                  NavBarElement(
                    image: 'assets/photos/navbarinfo.png',
                    text: 'Information',
                    ontap: () {
                      Navigator.pushNamed(context, InformationPage.id);
                    },
                  ),
                  SizedBox(
                    height: 15,
                    width: 86,
                    child: Center(
                      child: Text(
                        'Home',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                  NavBarElement(
                    image: 'assets/photos/navbaraboutus.png',
                    text: 'About Us',
                  ),
                  NavBarElement(
                    image: 'assets/photos/navbardoctor.png',
                    text: 'Doctors',
                    ontap: () {
                      Navigator.pushNamed(context, DoctorsPage.id);
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -25,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff17D3E5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/photos/navbarhome.png'),
              ),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 40,
        leadingWidth: 90,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) {
            return IconButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Image.asset('assets/photos/homev2_drawer.png'),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.05),
            Center(
              child: GradientText(
                'CancerScan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: screenWidth * 0.123,
                ),
                colors: [const Color(0xff12748B), const Color(0xff051F25)],
              ),
            ),
            SizedBox(height: 46),
            Text(
              'Recently',
              style: TextStyle(
                color: Color(0xff3674B5),
                fontSize: 22,
                fontWeight: FontWeight.w400,
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(11),
              height: screenHeight * 0.2,
              width: double.infinity,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (result != null &&
                      prediction != null &&
                      confidence != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Test result : ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '$result',
                              style: TextStyle(
                                color:
                                    result == 'Positive'
                                        ? Colors.red
                                        : Colors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '$formattedDate',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    Text(
                      'Cancer type : $prediction',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'confidence : $confidence%',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacer(flex: 1),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, HistoryPage.id);
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(screenWidth * 0.5, 32),
                          foregroundColor: kPrimaryColor,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          'Show all',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    SizedBox(height: 40),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "No recent test found.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 48),
            Text(
              'Doctors',
              style: TextStyle(
                color: Color(0xff3674B5),
                fontSize: 22,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 95,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  doctorCard(
                    context,
                    image: 'assets/doctor_photo/doctor1.jpg',
                    name: 'Dr: Mohmed',
                    location: 'Bani sweif',
                  ),
                  doctorCard(
                    context,
                    image: 'assets/doctor_photo/doctor2.jpg',
                    name: 'Dr: Mario',
                    location: 'Cairo',
                  ),
                  doctorCard(
                    context,
                    image: 'assets/doctor_photo/doctor3.jpg',
                    name: 'Dr: Youssef',
                    location: 'Cairo',
                  ),
                  doctorCard(
                    context,
                    image: 'assets/doctor_photo/doctor4.jpg',
                    name: 'Dr: Nadi',
                    location: 'Elshrouke',
                  ),
                  doctorCard(
                    context,
                    image: 'assets/doctor_photo/doctor5.jpg',
                    name: 'Dr: Marime',
                    location: 'Banha',
                  ),
                ],
              ),
            ),

            Transform.translate(
              offset: Offset(16, screenHeight * 0.05),
              child: Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, ChatPage.id);
                      },
                      child: Container(
                        height: 42,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Color(0xff17D3E5),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment(-0.6, 0),
                          child: Image.asset(
                            'assets/photos/gemini.png',
                            height: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Transform.translate(
              offset: Offset(16, screenHeight * 0.06),
              child: Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, MapPage.id);
                      },
                      child: Container(
                        height: 42,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Color(0xff17D3E5),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment(-0.4, 0),
                          child: Image.asset(
                            'assets/photos/homemap.png',
                            height: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget doctorCard(
    BuildContext context, {
    required String image,
    required String name,
    required String location,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            image,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            height: 60,
            width: 71,
          ),

          Container(
            height: 35,
            width: 71,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffD9D9D9), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),

                Row(
                  children: [
                    Image.asset('assets/photos/location.png', height: 10),
                    SizedBox(width: 4),
                    Text(
                      location,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget builddrawercategory(
    screenWidth,
    String text,
    String image, {
    VoidCallback? ontap,
  }) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                image,
                width: screenWidth * 0.07,
                height: screenWidth * 0.07,
              ),
              SizedBox(width: 4),
              Text(
                text,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth * 0.044,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getUserData(String filed) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc[filed];
  }

  Future<void> fetchLatestTestResult() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user logged in!");
      return;
    }

    // Reference to latest test document
    DocumentSnapshot latestTestDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('Latest_Test_Results')
            .doc('Latest')
            .get();

    if (latestTestDoc.exists && latestTestDoc.data() != null) {
      var data = latestTestDoc.data() as Map<String, dynamic>;

      // Extract values into variables
      result = data['Result'] ?? '';
      prediction = data['prediction'] ?? 'No Cancer';
      confidence = (data['confidence'] ?? 0).toDouble();
      timestamp = data['timestamp']; // Firestore Timestamp format

      formattedDate =
          timestamp != null
              ? DateFormat('dd-MM-yyyy').format(timestamp!.toDate())
              : 'Unknown Date';

      // Print results (for debugging)
      print("Image URL: $result");
      print("Prediction: $prediction");
      print("Confidence: $confidence");
      print(
        "Timestamp: ${timestamp?.toDate()}",
      ); // Convert Timestamp to DateTime
      setState(() {});
      // Now you can use these variables wherever needed!
    } else {
      print("No latest test result found.");
    }
  }

  Widget buildUserData({
    var filed,
    Color color = Colors.black,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return FutureBuilder<String>(
      future: getUserData(filed),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            'Loading...',
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          );
        }
        if (snapshot.hasError) {
          return Text(
            'Error loading name',
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          );
        }
        return Text(
          '${snapshot.data}',
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        );
      },
    );
  }
}

class NavBarElement extends StatelessWidget {
  const NavBarElement({super.key, this.image, this.text, this.ontap});
  final String? image;
  final String? text;
  final VoidCallback? ontap;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: GestureDetector(
        onTap: ontap,
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Image.asset(image!, height: 32),
            FittedBox(
              child: Text(
                text!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
