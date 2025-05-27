import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/Pages/info_pages/information_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BasalCellCarcinoma extends StatefulWidget {
  const BasalCellCarcinoma({super.key});

  static String id = 'BasalCellCarcinoma';

  @override
  State<BasalCellCarcinoma> createState() => _BasalCellCarcinomaState();
}

class _BasalCellCarcinomaState extends State<BasalCellCarcinoma> {
  String fileContent = "Loading...";
  @override
  void initState() {
    super.initState();
    loadTextFile();
  }

  Future<void> loadTextFile() async {
    String content = await rootBundle.loadString(
      'assets/information_text/Basal_Cell_Carcinoma_info.txt',
    );
    setState(() {
      fileContent = content;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffE3F7F5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(color: kPrimaryColor),
          child: AppBar(
            titleSpacing: 0,
            centerTitle: true,
            title: Text(
              'Basal Cell Carcinoma',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: screenWidth * 0.07,
              ),
            ),
            scrolledUnderElevation: 0,
            toolbarHeight: 40,
            leadingWidth: 90,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                Navigator.pushReplacementNamed(context, InformationPage.id);
              },
              icon: Image.asset(
                'assets/photos/dark_back_arrow.png',
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: screenHeight * 0.324,
            child: Image.asset(
              'assets/photos/Basal_Cell_Carcinoma_info.png',
              fit: BoxFit.fill,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  fileContent,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
