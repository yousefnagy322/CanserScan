// ignore_for_file: deprecated_member_use

import 'package:canser_scan/Pages/chatbot_page.dart';
import 'package:canser_scan/Pages/Login-Register/login_page.dart';
import 'package:canser_scan/Pages/Drawer/account_settings_page.dart';
import 'package:canser_scan/Pages/Drawer/app_language_page.dart';
import 'package:canser_scan/Pages/Doctors/doctor_details_page.dart';
import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/helper/get_user_build.dart';
import 'package:canser_scan/Pages/history_page.dart';
import 'package:canser_scan/Pages/map_page.dart';
import 'package:canser_scan/models/doctor.dart';
import 'package:canser_scan/widgets/bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../provider/navigation_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String id = "HomePageV2";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  Location location = Location();
  LatLng? userLatLng;
  List<Doctor> nearestDoctors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NavigationProvider>(
        context,
        listen: false,
      ).setSelectedIndex(2);
    });
    _getUserLocation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to route changes
    final ModalRoute? route = ModalRoute.of(context);
    if (route != null) {
      routeObserver.subscribe(this, route as PageRoute);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when this page is re-entered after a pop (e.g., back from InformationPage)
    Provider.of<NavigationProvider>(context, listen: false).setSelectedIndex(2);
  }

  Future<void> _getUserLocation() async {
    if (userLatLng != null) return;

    setState(() {
      _isLoading = true;
    });
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      var currentLocation = await location.getLocation();
      setState(() {
        userLatLng = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      drawer: const HomeDrawer(),
      bottomNavigationBar: const HomeBottomNavBar(),
      appBar: const HomeAppBar(),
      body: HomeBody(userLatLng: userLatLng, isLoading: _isLoading),
    );
  }
}

// Add this at the top of your file or in a separate file
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

// Drawer Widget
class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      backgroundColor: const Color(0xffFFFFFF),
      width: screenWidth * 0.5,
      child: Padding(
        padding: const EdgeInsets.only(left: 25),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 58),
              height: 180,
              child: Row(
                children: [
                  const SizedBox(width: 0),
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
              ontap: () => Navigator.pushNamed(context, AppLanguagePage.id),
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
          ],
        ),
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
          return Text(
            'Loading...',
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          );
        }
        return Text(
          snapshot.data!.replaceFirst(
            snapshot.data!,
            snapshot.data![0].toUpperCase() + snapshot.data!.substring(1),
          ),
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
      leadingWidth: 150,
      backgroundColor: Colors.transparent,

      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: FutureBuilder<String>(
          future: getUserData('First name'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text(
                'Loading...',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              );
            }
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hi ${snapshot.data!.replaceFirst(snapshot.data!, snapshot.data![0].toUpperCase() + snapshot.data!.substring(1))}', // Use 'snapshot.data',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        Align(
          alignment: Alignment.centerRight,
          child: Builder(
            builder: (context) {
              return IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: Image.asset('assets/photos/homev2_drawer.png'),
              );
            },
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40);
}

// Body Widget
class HomeBody extends StatelessWidget {
  final LatLng? userLatLng;
  final bool isLoading;

  const HomeBody({
    super.key,
    required this.userLatLng,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    final User? user = FirebaseAuth.instance.currentUser;

    return Stack(
      children: [
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
                    height: 1,
                  ),
                  colors: const [Color(0xff12748B), Color(0xff051F25)],
                ),
              ),
              Center(
                child: Text(
                  'Skin Cancer Detector',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff3674B5).withOpacity(0.8),
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.040,
                    height: 1,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              const Text(
                'Latest Test',
                style: TextStyle(
                  color: Color(0xff3674B5),
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user?.uid)
                        .collection('Test_Results')
                        .orderBy('timestamp', descending: true)
                        .limit(1)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
                  var data =
                      snapshot.data!.docs.first.data() as Map<String, dynamic>;
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
              SizedBox(height: screenHeight * 0.05),
              const Text(
                'Nearest Doctors',
                style: TextStyle(
                  color: Color(0xff3674B5),
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.110,
                child:
                    isLoading
                        ? const Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                          ),
                        )
                        : userLatLng == null
                        ? const Center(child: Text('Location unavailable'))
                        : StreamBuilder<QuerySnapshot>(
                          stream:
                              FirebaseFirestore.instance
                                  .collection('dermatologists')
                                  .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: Text('No doctors found nearby'),
                              );
                            }

                            final List<Doctor> tempDoctors =
                                snapshot.data!.docs
                                    .map((doc) => Doctor.fromFirestore(doc))
                                    .where(
                                      (doctor) =>
                                          doctor.lat != 0.0 &&
                                          doctor.lng != 0.0,
                                    )
                                    .toList();

                            tempDoctors.sort(
                              (a, b) => Geolocator.distanceBetween(
                                userLatLng!.latitude,
                                userLatLng!.longitude,
                                a.lat,
                                a.lng,
                              ).compareTo(
                                Geolocator.distanceBetween(
                                  userLatLng!.latitude,
                                  userLatLng!.longitude,
                                  b.lat,
                                  b.lng,
                                ),
                              ),
                            );

                            final nearestDoctors = tempDoctors.take(4).toList();

                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: nearestDoctors.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => DoctorDetailsPage(
                                              doctor: nearestDoctors[index],
                                            ),
                                      ),
                                    );
                                  },
                                  child: doctorCard(
                                    context,
                                    image: nearestDoctors[index].image,
                                    name: nearestDoctors[index].name,
                                    location: nearestDoctors[index].governorate,
                                  ),
                                );
                              },
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: screenHeight * 0.06,
          right: 0,
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
          right: 0,
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
      height: screenHeight * 0.18,
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
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    result,
                    style: TextStyle(
                      color: result == 'Positive' ? Colors.red : Colors.green,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Text(
                formattedDate,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          Text(
            'Cancer type : $prediction',
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'confidence : $confidence%',
            style: const TextStyle(
              fontSize: 15,
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
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: screenHeight * 0.105, // Match SizedBox height
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              height: screenHeight * 0.064, // Reduced from 0.064
              width: screenWidth * 0.173,
              placeholder:
                  (context, url) => Container(
                    height: screenHeight * 0.055,
                    width: screenWidth * 0.173,
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    ),
                  ),
              errorWidget:
                  (context, url, error) => Image.asset(
                    'assets/doctor_photo/default_doctor.jpg',
                    fit: BoxFit.cover,
                    height: screenHeight * 0.055,
                    width: screenWidth * 0.173,
                  ),
            ),
          ),
          Container(
            height: screenHeight * 0.04, // Reduced from 0.05
            width: screenWidth * 0.173,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffD9D9D9), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    textAlign: TextAlign.left,
                    name.split(' ').take(2).join(' '), // "Dr. Ahmed"
                    maxLines: 1,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: screenHeight * 0.0133,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        location,
                        style: TextStyle(
                          height: 0,
                          color: kPrimaryColor,
                          fontSize: screenHeight * 0.0133,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
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
