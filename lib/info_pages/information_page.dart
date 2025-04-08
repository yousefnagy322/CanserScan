import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/info_pages/actinic_keratosis.dart';
import 'package:canser_scan/info_pages/basal_cell_carcinoma.dart';
import 'package:canser_scan/info_pages/benign_keratosis.dart';
import 'package:canser_scan/info_pages/dermatofibroma.dart';
import 'package:canser_scan/info_pages/melanocytic_nevus.dart';
import 'package:canser_scan/info_pages/melanoma.dart';
import 'package:canser_scan/info_pages/skin_cancer.dart';
import 'package:canser_scan/info_pages/vascular_lesion.dart';
import 'package:canser_scan/navigation_provider.dart';
import 'package:canser_scan/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Data model for a disease
class Disease {
  final String title;
  final String subtitle;
  final String destination;

  const Disease({
    required this.title,
    required this.subtitle,
    required this.destination,
  });
}

// InformationPage Widget
class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  static const String id = 'InformationPage';

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NavigationProvider>(
        context,
        listen: false,
      ).setSelectedIndex(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        // Update the selectedIndex to the previous page's index
        Provider.of<NavigationProvider>(context, listen: false).popIndex();
        return true; // Allow the pop to proceed
      },
      child: Scaffold(
        backgroundColor: const Color(0xffE3F7F5),
        bottomNavigationBar: const HomeBottomNavBar(),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff56EACF), Color(0xff194D59)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: const Text(
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
            ),
          ),
        ),
        body: ListView.builder(
          itemCount: 8,
          itemBuilder: (context, index) {
            final diseases = [
              Disease(
                title: "What is skin cancer",
                subtitle: "Info with details about skin cancer",
                destination: SkinCancer.id,
              ),
              Disease(
                title: "Benign Keratosis",
                subtitle: "Benign skin lesion",
                destination: BenignKeratosis.id,
              ),
              Disease(
                title: "Vascular Lesion",
                subtitle: "Benign skin lesion",
                destination: VascularLesion.id,
              ),
              Disease(
                title: "Melanoma",
                subtitle: "Malignant skin lesion",
                destination: Melanoma.id,
              ),
              Disease(
                title: "Melanocytic Nevus",
                subtitle: "Malignant skin lesion",
                destination: MelanocyticNevus.id,
              ),
              Disease(
                title: "Dermatofibroma",
                subtitle: "Benign skin lesion",
                destination: Dermatofibroma.id,
              ),
              Disease(
                title: "Actinic Keratosis",
                subtitle: "Benign skin lesion",
                destination: ActinicKeratosis.id,
              ),
              Disease(
                title: "Basal Cell Carcinoma",
                subtitle: "Malignant skin lesion",
                destination: BasalCellCarcinoma.id,
              ),
            ];
            final disease = diseases[index];
            return diseaseCard(
              context,
              title: disease.title,
              subtitle: disease.subtitle,
              destination: disease.destination,
              screenWidth: screenWidth,
            );
          },
        ),
      ),
    );
  }

  Widget diseaseCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String destination,
    required double screenWidth,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: const Icon(Icons.info, color: kPrimaryColor),
        title: Text(
          title,
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: screenWidth * 0.035),
        ),
        onTap: () {
          Navigator.pushNamed(context, destination);
        },
      ),
    );
  }
}
