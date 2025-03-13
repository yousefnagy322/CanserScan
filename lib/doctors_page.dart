import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/home_page_v2.dart';
import 'package:canser_scan/info_pages/information_page.dart';
import 'package:canser_scan/test/take_test_page.dart';
import 'package:flutter/material.dart';
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
      body: Container(),
    );
  }
}
