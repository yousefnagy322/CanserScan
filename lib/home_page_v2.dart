import 'package:canser_scan/Chatbot/chat_page.dart';
import 'package:canser_scan/Login-Register/login_page.dart';
import 'package:canser_scan/account_settings.dart';
import 'package:canser_scan/add_doctor_page.dart';
import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/history_page.dart';
import 'package:canser_scan/map_page.dart';
import 'package:canser_scan/widgets/bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:intl/intl.dart';
import 'navigation_provider.dart';

// Data model for navigation bar items
class NavBarItem {
  final String icon;
  final String label;
  final String? route;
  final bool isActive;

  const NavBarItem({
    required this.icon,
    required this.label,
    this.route,
    this.isActive = false,
  });
}

class HomePageV2 extends StatefulWidget {
  const HomePageV2({super.key});
  static const String id = "HomePageV2";

  @override
  State<HomePageV2> createState() => _HomePageV2State();
}

class _HomePageV2State extends State<HomePageV2> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NavigationProvider>(
        context,
        listen: false,
      ).setSelectedIndex(2);
    });
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    final User? user = FirebaseAuth.instance.currentUser;

    return const Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      drawer: HomeDrawer(),
      bottomNavigationBar: HomeBottomNavBar(),
      appBar: HomeAppBar(),
      body: HomeBody(),
    );
  }
}

// Drawer Widget
class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      backgroundColor: const Color(0xffFFFFFF),
      width: screenWidth * 0.5,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 58),
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
                  field: 'First name',
                  color: Colors.black,
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
          buildDrawerCategory(
            screenWidth,
            'settings',
            'assets/photos/settings.png',
            ontap: () => Navigator.pushNamed(context, AccountSettings.id),
          ),
          buildDrawerCategory(
            screenWidth,
            'Language',
            'assets/photos/language.png',
          ),
          buildDrawerCategory(
            screenWidth,
            'Log Out',
            'assets/photos/logout.png',
            ontap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, LoginPage.id);
            },
          ),
          buildDrawerCategory(
            screenWidth,
            'Add Doctor',
            'assets/photos/logout.png',
            ontap: () {
              Navigator.pushReplacementNamed(context, AddDoctorPage.id);
            },
          ),
        ],
      ),
    );
  }

  Widget buildDrawerCategory(
    double screenWidth,
    String text,
    String image, {
    VoidCallback? ontap,
  }) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              image,
              width: screenWidth * 0.07,
              height: screenWidth * 0.07,
            ),
            const SizedBox(width: 4),
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
    );
  }

  Widget buildUserData({
    required String field,
    Color color = Colors.black,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return FutureBuilder<String>(
      future: getUserData(field),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text(
            'Loading...',
            style: TextStyle(color: Colors.black),
          );
        }
        return Text(
          snapshot.data ?? 'Unknown',
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        );
      },
    );
  }

  Future<String> getUserData(String field) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc[field] ?? 'Unknown';
  }
}

// AppBar Widget
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      toolbarHeight: 40,
      leadingWidth: 90,
      backgroundColor: Colors.transparent,
      leading: Builder(
        builder: (context) {
          return IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Image.asset('assets/photos/homev2_drawer.png'),
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40);
}

// Body Widget
class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    final User? user = FirebaseAuth.instance.currentUser;

    return Stack(
      children: [
        // Main content with padding
        Padding(
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
                  colors: const [Color(0xff12748B), Color(0xff051F25)],
                ),
              ),
              const SizedBox(height: 46),
              const Text(
                'Recently',
                style: TextStyle(
                  color: Color(0xff3674B5),
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
              StreamBuilder<DocumentSnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user?.uid)
                        .collection('Latest_Test_Results')
                        .doc('Latest')
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data?.data() == null) {
                    return Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(11),
                      height: screenHeight * 0.2,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: const Text(
                        "No recent test found.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }
                  var data = snapshot.data!.data() as Map<String, dynamic>;
                  final result = data['Result'] ?? '';
                  final prediction = data['prediction'] ?? 'No Cancer';
                  final confidence = (data['confidence'] ?? 0).toDouble();
                  final timestamp = data['timestamp'] as Timestamp?;
                  final formattedDate =
                      timestamp != null
                          ? DateFormat('dd-MM-yyyy').format(timestamp.toDate())
                          : 'Unknown Date';

                  return buildTestResultWidget(
                    screenHeight,
                    result,
                    prediction,
                    confidence,
                    formattedDate,
                    context,
                  );
                },
              ),
              const SizedBox(height: 48),
              const Text(
                'Doctors',
                style: TextStyle(
                  color: Color(0xff3674B5),
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 95,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final doctors = [
                      {
                        'image': 'assets/doctor_photo/Dr Mohmed Nadi.jpg',
                        'name': 'Dr: Mohmed',
                        'location': 'Bani sweif',
                      },
                      {
                        'image': 'assets/doctor_photo/Dr Mario Abrahime.jpg',
                        'name': 'Dr: Mario',
                        'location': 'Cairo',
                      },
                      {
                        'image': 'assets/doctor_photo/Dr Youssef Ahmed.jpg',
                        'name': 'Dr: Youssef',
                        'location': 'Cairo',
                      },
                      {
                        'image': 'assets/doctor_photo/Dr Nadi Youssef.jpg',
                        'name': 'Dr: Nadi',
                        'location': 'Elshrouke',
                      },
                      {
                        'image': 'assets/doctor_photo/Dr Marime Emad.jpg',
                        'name': 'Dr: Marime',
                        'location': 'Banha',
                      },
                    ];
                    return doctorCard(
                      context,
                      image: doctors[index]['image']!,
                      name: doctors[index]['name']!,
                      location: doctors[index]['location']!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // Buttons without padding to touch the edge
        Positioned(
          bottom: screenHeight * 0.06,
          right: 0, // No padding on the right
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, MapPage.id),
            child: Container(
              height: 42,
              width: 50,
              decoration: const BoxDecoration(
                color: Color(0xff17D3E5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
              ),
              child: Align(
                alignment: const Alignment(-0.4, 0),
                child: Image.asset('assets/photos/homemap.png', height: 32),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: screenHeight * 0.12,
          right: 0, // No padding on the right
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, ChatPage.id),
            child: Container(
              height: 42,
              width: 80,
              decoration: const BoxDecoration(
                color: Color(0xff17D3E5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
              ),
              child: Align(
                alignment: const Alignment(-0.6, 0),
                child: Image.asset('assets/photos/gemini.png', height: 32),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTestResultWidget(
    double screenHeight,
    String result,
    String prediction,
    double confidence,
    String formattedDate,
    BuildContext context,
  ) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(11),
      height: screenHeight * 0.2,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Test result : ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    result,
                    style: TextStyle(
                      color: result == 'Positive' ? Colors.red : Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Text(
                formattedDate,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          Text(
            'Cancer type : $prediction',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'confidence : $confidence%',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(flex: 1),
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, HistoryPage.id),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(screenHeight * 0.5, 32),
                foregroundColor: kPrimaryColor,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Show all',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
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
              border: Border.all(color: const Color(0xffD9D9D9), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  children: [
                    Image.asset('assets/photos/location.png', height: 10),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: const TextStyle(
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
}
