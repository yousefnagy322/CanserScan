import 'package:canser_scan/account_settings.dart';
import 'package:canser_scan/test/take_test_page.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static String id = "HomePage";
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Scaffold(
        drawer: Drawer(
          backgroundColor: Color(0xffEBEBEB),
          width: screenWidth * 0.5,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 58),
                height: 180,
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    Image.asset(
                      'assets/photos/drawer_person.png',
                      height: screenWidth * 0.1,
                      width: screenWidth * 0.1,
                    ),
                    Text(
                      'Yousef',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  ],
                ),
              ),
              builddrawercategory(
                screenWidth,
                'settings',
                'assets/photos/settings.png',
                ontap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountSettings()),
                  );
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
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            // Top Background
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/photos/home_top.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Bottom Background
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'assets/photos/home_bottom.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenWidth * 0.14,
                  horizontal: screenWidth * 0.1,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: screenWidth * 0.1,
                      width: screenWidth * 0.3,
                      child: Builder(
                        builder: (context) {
                          return GestureDetector(
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                            child: Row(
                              children: [
                                Image.asset('assets/photos/person.png'),
                                Text(
                                  'Yousef',
                                  style: TextStyle(
                                    color: Color(0xff194D59),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.12),
                    Center(
                      child: GradientText(
                        'CancerScan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: screenWidth * 0.123,
                        ),
                        colors: [Color(0xff12748B), Color(0xff051F25)],
                      ),
                    ),
                    SizedBox(height: 125),
                    buildnewbutton(
                      screenWidth,
                      'Take test',
                      'assets/photos/test.png',
                      onpressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TakeTestPage(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 24),
                    buildnewbutton(
                      screenWidth,
                      'Information',
                      'assets/photos/information.png',
                    ),
                    SizedBox(height: 24),
                    buildnewbutton(
                      screenWidth,
                      'History',
                      'assets/photos/history.png',
                    ),
                    SizedBox(height: 24),
                    buildnewbutton(
                      screenWidth,
                      'About us',
                      'assets/photos/about us.png',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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

  Widget buildnewbutton(
    double screenWidth,
    String? text,
    String? image, {
    VoidCallback? onpressed,
  }) {
    return Center(
      child: ElevatedButton(
        onPressed: onpressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(screenWidth * 0.8, 54),
          foregroundColor: Colors.white,
          backgroundColor: Color(0xff194D59),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              '$image',
              height: screenWidth * 0.15,
              width: screenWidth * 0.08,
            ),
            SizedBox(width: 8),
            Text(
              '$text',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
