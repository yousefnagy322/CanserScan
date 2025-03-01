import 'package:flutter/material.dart';

class TakeTestPage extends StatelessWidget {
  const TakeTestPage({super.key});

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
                  child: Column(
                    children: [
                      buildbox(screenWidth, 'assets/photos/take_photo.png'),
                      SizedBox(height: 8),
                      buildlabel(screenWidth, 'Take Photo'),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.09),
                  child: Column(
                    children: [
                      buildbox(screenWidth, 'assets/photos/Choose_image.png'),
                      SizedBox(height: 8),
                      buildlabel(screenWidth, 'Choose Image'),
                    ],
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
