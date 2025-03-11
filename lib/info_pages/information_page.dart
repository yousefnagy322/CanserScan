import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/home_page_v2.dart';
import 'package:canser_scan/info_pages/actinic_keratosis.dart';
import 'package:canser_scan/info_pages/basal_cell_carcinoma.dart';
import 'package:canser_scan/info_pages/benign_keratosis.dart';
import 'package:canser_scan/info_pages/dermatofibroma.dart';
import 'package:canser_scan/info_pages/melanocytic_nevus.dart';
import 'package:canser_scan/info_pages/melanoma.dart';
import 'package:canser_scan/info_pages/skin_cancer.dart';
import 'package:canser_scan/info_pages/vascular_lesion.dart';
import 'package:flutter/material.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({super.key});

  static String id = 'InformationPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE3F7F5),
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
            centerTitle: true,
            title: Text(
              'Information',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
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
      body: ListView(
        children: [
          diseaseCard(
            context,
            title: "What is skin cancer",
            subtitle: "Info with details about skin cancer",
            destination: SkinCancer.id,
          ),
          diseaseCard(
            context,
            title: "Benign Keratosis",
            subtitle: "Benign skin lesion",
            destination: BenignKeratosis.id,
          ),
          diseaseCard(
            context,
            title: "Vascular Lesion",
            subtitle: "Benign skin lesion",
            destination: VascularLesion.id,
          ),
          diseaseCard(
            context,
            title: "Melanoma",
            subtitle: "Malignant skin lesion",
            destination: Melanoma.id,
          ),
          diseaseCard(
            context,
            title: "Melanocytic Nevus",
            subtitle: "Malignant skin lesion",
            destination: MelanocyticNevus.id,
          ),
          diseaseCard(
            context,
            title: "Dermatofibroma",
            subtitle: "Benign skin lesion",
            destination: Dermatofibroma.id,
          ),
          diseaseCard(
            context,
            title: "Actinic Keratosis",
            subtitle: "Benign skin lesion",
            destination: ActinicKeratosis.id,
          ),
          diseaseCard(
            context,
            title: "Basal Cell Carcinoma",
            subtitle: "Malignant skin lesion",
            destination: BasalCellCarcinoma.id,
          ),
        ],
      ),
    );
  }

  Widget diseaseCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required var destination,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: const Icon(Icons.info, color: kPrimaryColor),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        onTap: () {
          Navigator.pushNamed(context, destination);
        },
      ),
    );
  }
}
