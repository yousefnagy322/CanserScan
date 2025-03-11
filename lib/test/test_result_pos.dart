import 'package:canser_scan/helper/constants.dart';
import 'package:flutter/material.dart';

class TestResultPos extends StatelessWidget {
  String? highestClassApi;
  int? highestConfidenceApi;
  String? highestClassModel;
  int? highestConfidenceModel;

  TestResultPos({
    super.key,
    this.highestClassApi,
    this.highestConfidenceApi,
    this.highestClassModel,
    this.highestConfidenceModel,
  });
  static String id = 'TestResultPos';
  @override
  Widget build(BuildContext context) {
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
            SizedBox(height: 100),
            Text(
              'Test Result',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Postive',
              style: TextStyle(
                color: Colors.red,
                fontSize: 32,
                fontWeight: FontWeight.w400,
              ),
            ),
            Container(
              height: 270,
              width: 300,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Text(
                    'Cancer Type API',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '$highestClassApi',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    'Confidence',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    '${highestConfidenceApi!}%',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    'Cancer Type Model',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '$highestClassModel',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    'Confidence',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    '${highestConfidenceApi!}%',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
