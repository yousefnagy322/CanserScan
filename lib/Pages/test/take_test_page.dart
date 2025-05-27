// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/provider/navigation_provider.dart';
import 'package:canser_scan/Pages/test/take_test_confirm_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:canser_scan/widgets/bottom_nav_bar.dart';

class TakeTestPage extends StatefulWidget {
  const TakeTestPage({super.key});
  static const String id = 'TakeTestPage';

  @override
  State<TakeTestPage> createState() => _TakeTestPageState();
}

class _TakeTestPageState extends State<TakeTestPage> {
  File? _imageFile;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Set the selectedIndex to 0 (Test tab) when the page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NavigationProvider>(
        context,
        listen: false,
      ).setSelectedIndex(0);
    });
  }

  Future<void> pickImageGallery(BuildContext context) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }

    if (_imageFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TakeTestConfirmPage(imageFile: _imageFile),
        ),
      );
    }
  }

  Future<void> pickImageCamera(BuildContext context) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }

    if (_imageFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TakeTestConfirmPage(imageFile: _imageFile),
        ),
      );
    }
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
        backgroundColor: Colors.white,
        bottomNavigationBar: const HomeBottomNavBar(),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: const BoxDecoration(color: kPrimaryColor),
            child: AppBar(
              centerTitle: true,
              title: Text(
                'Take Test',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: screenWidth * 0.08,
                ),
              ),
              automaticallyImplyLeading: false,
              scrolledUnderElevation: 0,
              toolbarHeight: 40,
              leadingWidth: 90,
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.25),

              Text(
                'Choose Between',
                style: TextStyle(
                  color: const Color(0xff194D59),
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      pickImageCamera(context);
                    },
                    child: Column(
                      children: [
                        buildBox(screenWidth, 'assets/photos/take_photo.png'),
                        const SizedBox(height: 8),
                        buildLabel(screenWidth, 'Take Photo'),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      pickImageGallery(context);
                    },
                    child: Column(
                      children: [
                        buildBox(screenWidth, 'assets/photos/Choose_image.png'),
                        const SizedBox(height: 8),
                        buildLabel(screenWidth, 'Choose Image'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text buildLabel(double screenWidth, String text) {
    return Text(
      text,
      style: TextStyle(
        color: const Color(0xff194D59),
        fontSize: screenWidth * 0.04,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Container buildBox(double screenWidth, String image) {
    return Container(
      width: screenWidth * 0.363,
      height: screenWidth * 0.31,
      decoration: const BoxDecoration(
        color: Color(0xff194D59),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Image.asset(image, scale: 1.5),
    );
  }
}
