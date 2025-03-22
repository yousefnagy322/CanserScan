import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/home_page_v2.dart';
import 'package:canser_scan/info_pages/information_page.dart';
import 'package:canser_scan/map_page.dart';
import 'package:canser_scan/test/take_test_page.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:simple_shadow/simple_shadow.dart';

class DoctorsPage extends StatelessWidget {
  const DoctorsPage({super.key});
  static String id = 'DoctorsPage';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
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

                  NavBarElement(
                    image: 'assets/photos/navbarhome.png',
                    text: 'Home',
                    ontap: () {
                      Navigator.pushNamed(context, HomePageV2.id);
                    },
                  ),
                  NavBarElement(
                    image: 'assets/photos/navbaraboutus.png',
                    text: 'About Us',
                  ),
                  SizedBox(
                    height: 15,
                    width: 86,
                    child: Center(
                      child: Text(
                        'Doctors',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: screenWidth - 67,
            top: -25,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff17D3E5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Image.asset('assets/photos/navbardoctor.png'),
              ),
            ),
          ),
        ],
      ),

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
                Navigator.pushReplacementNamed(context, HomePageV2.id);
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
                colors: [const Color(0xff12748B), const Color(0xff051F25)],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  doctorCard(
                    context,
                    image: 'assets/doctor_photo/doctor1.jpg',
                    name: 'Dr: Mohmed Nadi',
                    location: 'Bani sweif',
                    onpressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MapPage(
                                doctorLat: 29.06882555330429,
                                doctorLng: 31.100216595764856,
                              ),
                        ),
                      );
                      print('go to page');
                    },
                  ),
                  doctorCard(
                    context,
                    image: 'assets/doctor_photo/doctor2.jpg',
                    name: 'Dr: Mario Abrahime',
                    location: 'Cairo',
                    onpressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MapPage(
                                doctorLat: 30.06073316874439,
                                doctorLng: 31.24660416741735,
                              ),
                        ),
                      );
                      print('go to page');
                    },
                  ),
                  doctorCard(
                    context,
                    image: 'assets/doctor_photo/doctor3.jpg',
                    name: 'Dr: Youssef Ahmed',
                    location: 'Cairo',
                    onpressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MapPage(
                                doctorLat: 30.031006164144912,
                                doctorLng: 31.203126928235857,
                              ),
                        ),
                      );
                      print('go to page');
                    },
                  ),
                  doctorCard(
                    context,
                    image: 'assets/doctor_photo/doctor4.jpg',
                    name: 'Dr: Nadi Youssef',
                    location: 'Elshrouke',
                    onpressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MapPage(
                                doctorLat: 30.159547580564148,
                                doctorLng: 31.601435209234975,
                              ),
                        ),
                      );
                      print('go to page');
                    },
                  ),
                  doctorCard(
                    context,
                    image: 'assets/doctor_photo/doctor5.jpg',
                    name: 'Dr: Marime Emad',
                    location: 'Banha',
                    onpressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MapPage(
                                doctorLat: 30.46660724434177,
                                doctorLng: 31.186129109143007,
                              ),
                        ),
                      );
                      print('go to page');
                    },
                  ),
                ],
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
    VoidCallback? onpressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            image,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            height: 80,
            width: 70,
          ),
          SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              Row(
                children: [
                  Image.asset('assets/photos/location.png', height: 16),
                  SizedBox(width: 4),
                  Text(
                    location,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
          Spacer(flex: 1),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(8),
              fixedSize: const Size(64, 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            onPressed: onpressed,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Map',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
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
