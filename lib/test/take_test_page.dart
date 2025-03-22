import 'dart:io';
import 'package:canser_scan/doctors_page.dart';
import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/home_page_v2.dart';
import 'package:canser_scan/info_pages/information_page.dart';
import 'package:canser_scan/test/take_test_confirm_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';

class TakeTestPage extends StatelessWidget {
  TakeTestPage({super.key});
  static String id = 'TakeTestPage';

  File? imageFile;

  final picker = ImagePicker();

  pickimagegallery(context) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }

    if (imageFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TakeTestConfirmPage(imageFile: imageFile),
        ),
      );
    }
  }

  pickimagecamera(context) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }

    if (imageFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TakeTestConfirmPage(imageFile: imageFile),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
                  SizedBox(
                    height: 15,
                    width: 86,
                    child: Center(
                      child: Text(
                        'Test',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
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
            right: screenWidth - 67,
            top: -25,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff17D3E5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Image.asset('assets/photos/navbartest.png'),
              ),
            ),
          ),
        ],
      ),

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
                imageFile = null;
                Navigator.pushReplacementNamed(context, HomePageV2.id);
              },
              icon: Image.asset('assets/photos/dark_back_arrow.png'),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 200),
            Text(
              'Take test',
              style: TextStyle(
                color: Color(0xff194D59),
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Choose Between',
              style: TextStyle(
                color: Color(0xff194D59),
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.09),
                  child: GestureDetector(
                    onTap: () {
                      pickimagecamera(context);
                    },
                    child: Column(
                      children: [
                        buildbox(screenWidth, 'assets/photos/take_photo.png'),
                        SizedBox(height: 8),
                        buildlabel(screenWidth, 'Take Photo'),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.09),
                  child: GestureDetector(
                    onTap: () {
                      pickimagegallery(context);
                    },
                    child: Column(
                      children: [
                        buildbox(screenWidth, 'assets/photos/Choose_image.png'),
                        SizedBox(height: 8),
                        buildlabel(screenWidth, 'Choose Image'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Text buildlabel(double screenWidth, String text) {
    return Text(
      text,
      style: TextStyle(
        color: Color(0xff194D59),
        fontSize: screenWidth * 0.04,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Container buildbox(double screenWidth, String image) {
    return Container(
      width: screenWidth * 0.363,
      height: screenWidth * 0.31,
      decoration: BoxDecoration(
        color: Color(0xff194D59),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Image.asset(image, scale: 1.5),
    );
  }
}
