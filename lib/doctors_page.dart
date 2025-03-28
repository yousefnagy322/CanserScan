import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/map_page.dart';
import 'package:canser_scan/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'navigation_provider.dart';

// Data model for a doctor
class Doctor {
  final String image;
  final String name;
  final String location;
  final double lat;
  final double lng;

  const Doctor({
    required this.image,
    required this.name,
    required this.location,
    required this.lat,
    required this.lng,
  });
}

// DoctorsPage Widget
class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});
  static const String id = 'DoctorsPage';

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NavigationProvider>(
        context,
        listen: false,
      ).setSelectedIndex(4);
    });
  }

  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      bottomNavigationBar:
          const HomeBottomNavBar(), // Use the optimized HomeBottomNavBar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(color: Color(0xffFFFFFF)),
          child: AppBar(
            centerTitle: true,
            scrolledUnderElevation: 0,
            toolbarHeight: 40,
            leadingWidth: 90,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                Navigator.pop(
                  context,
                ); // Changed to pop instead of pushReplacementNamed
              },
              icon: Image.asset('assets/photos/dark_back_arrow.png'),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            Center(
              child: GradientText(
                'Doctors',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: screenWidth * 0.123,
                ),
                colors: const [Color(0xff12748B), Color(0xff051F25)],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  final doctors = [
                    Doctor(
                      image: 'assets/doctor_photo/Dr Mohmed Nadi.jpg',
                      name: 'Dr: Mohmed Nadi',
                      location: 'Bani sweif',
                      lat: 29.06882555330429,
                      lng: 31.100216595764856,
                    ),
                    Doctor(
                      image: 'assets/doctor_photo/Dr Mario Abrahime.jpg',
                      name: 'Dr: Mario Abrahime',
                      location: 'Cairo',
                      lat: 30.06073316874439,
                      lng: 31.24660416741735,
                    ),
                    Doctor(
                      image: 'assets/doctor_photo/Dr Youssef Ahmed.jpg',
                      name: 'Dr: Youssef Ahmed',
                      location: 'Cairo',
                      lat: 30.031006164144912,
                      lng: 31.203126928235857,
                    ),
                    Doctor(
                      image: 'assets/doctor_photo/Dr Nadi Youssef.jpg',
                      name: 'Dr: Nadi Youssef',
                      location: 'Elshrouke',
                      lat: 30.159547580564148,
                      lng: 31.601435209234975,
                    ),
                    Doctor(
                      image: 'assets/doctor_photo/Dr Marime Emad.jpg',
                      name: 'Dr: Marime Emad',
                      location: 'Banha',
                      lat: 30.46660724434177,
                      lng: 31.186129109143007,
                    ),
                  ];
                  final doctor = doctors[index];
                  return doctorCard(
                    context,
                    image: doctor.image,
                    name: doctor.name,
                    location: doctor.location,
                    doctorLat: doctor.lat,
                    doctorLng: doctor.lng,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  );
                },
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
    required double doctorLat,
    required double doctorLng,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: screenHeight * 0.1, // Responsive height (10% of screen height)
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            image,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            height: screenHeight * 0.1, // Responsive height
            width: screenWidth * 0.18, // Responsive width (18% of screen width)
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: screenWidth * 0.045, // Responsive font size
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/photos/location.png',
                    height: screenWidth * 0.04, // Responsive icon size
                  ),
                  const SizedBox(width: 4),
                  Text(
                    location,
                    style: TextStyle(
                      fontSize: screenWidth * 0.038, // Responsive font size
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(flex: 1),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(8),
              fixedSize: Size(
                screenWidth * 0.16,
                screenHeight * 0.04,
              ), // Responsive button size
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          MapPage(doctorLat: doctorLat, doctorLng: doctorLng),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Map',
                  style: TextStyle(
                    fontSize: screenWidth * 0.03, // Responsive font size
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Image.asset('assets/photos/mapicon.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
