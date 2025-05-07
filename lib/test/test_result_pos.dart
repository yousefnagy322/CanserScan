// ignore_for_file: must_be_immutable

import 'package:canser_scan/doctors_page.dart';
import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/info_pages/actinic_keratosis.dart';
import 'package:canser_scan/info_pages/basal_cell_carcinoma.dart';
import 'package:canser_scan/info_pages/benign_keratosis.dart';
import 'package:canser_scan/info_pages/dermatofibroma.dart';
import 'package:canser_scan/info_pages/melanocytic_nevus.dart';
import 'package:canser_scan/info_pages/melanoma.dart';
import 'package:canser_scan/info_pages/vascular_lesion.dart';
import 'package:canser_scan/test/take_test_page.dart';
import 'package:canser_scan/widgets/main_custom_button.dart';
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(color: kPrimaryColor),
          child: AppBar(
            titleSpacing: 0,
            centerTitle: true,
            title: Text(
              'Test Result',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: screenWidth * 0.08,
              ),
            ),
            scrolledUnderElevation: 0,
            toolbarHeight: 40,
            leadingWidth: 90,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset(
                'assets/photos/dark_back_arrow.png',
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 100),

            SizedBox(height: 30),
            Text(
              'Positive',
              style: TextStyle(
                color: Colors.red,
                fontSize: 32,
                fontWeight: FontWeight.w400,
              ),
            ),
            Container(
              height: screenHeight * 0.22,
              width: screenWidth * 0.6,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Text(
                    'Cancer Type',
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
                  const SizedBox(height: 20),
                  Text(
                    'Confidence',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    '${highestConfidenceModel!}%',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            BuildCustomButton(
              color: kPrimaryColor,
              buttonText: 'Another test',
              onPressed: () {
                Navigator.pushReplacementNamed(context, TakeTestPage.id);
              },
            ),
            const SizedBox(height: 32),
            BuildCustomButton(
              color: kPrimaryColor,
              buttonText: 'More info',
              onPressed: () {
                if (highestClassApi == 'Benign Keratosis') {
                  Navigator.pushNamed(context, BenignKeratosis.id);
                } else if (highestClassApi == 'Vascular Lesion') {
                  Navigator.pushNamed(context, VascularLesion.id);
                } else if (highestClassApi == 'Melanoma') {
                  Navigator.pushNamed(context, Melanoma.id);
                } else if (highestClassApi == 'Melanocytic Nevus') {
                  Navigator.pushNamed(context, MelanocyticNevus.id);
                } else if (highestClassApi == 'Dermatofibroma') {
                  Navigator.pushNamed(context, Dermatofibroma.id);
                } else if (highestClassApi == 'Actinic Keratosis') {
                  Navigator.pushNamed(context, ActinicKeratosis.id);
                } else if (highestClassApi == 'Basal Cell Carcinoma') {
                  Navigator.pushNamed(context, BasalCellCarcinoma.id);
                }
              },
            ),
            const SizedBox(height: 32),
            BuildCustomButton(
              color: kPrimaryColor,
              buttonText: 'Find doctor',
              onPressed: () {
                Navigator.pushNamed(context, DoctorsPage.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
