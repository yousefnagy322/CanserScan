import 'dart:convert';
import 'dart:io';
import 'package:canser_scan/test/take_test_page.dart';
import 'package:canser_scan/test/test_result_neg.dart';
import 'package:canser_scan/test/test_result_pos.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class TakeTestConfirmPage extends StatefulWidget {
  File? imageFile;

  TakeTestConfirmPage({super.key, this.imageFile});
  static String id = 'TakeTestConfirmPage';

  @override
  State<TakeTestConfirmPage> createState() => _TakeTestConfirmPageState();
}

class _TakeTestConfirmPageState extends State<TakeTestConfirmPage> {
  String highestClass = '';
  int confidencePercentage = 0;
  double highestConfidence = 0;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      color: Colors.white70,
      progressIndicator: CircularProgressIndicator(color: Colors.white),

      child: Scaffold(
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
                  widget.imageFile = null;
                  Navigator.pushReplacementNamed(context, TakeTestPage.id);
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
              SizedBox(height: 50),
              Center(
                child: Column(
                  children: [
                    buildbox(screenWidth, 'assets/photos/confirm_photo.png'),
                    SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () async {
                        if (widget.imageFile != null) {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            await classifyImageAPI(widget.imageFile!);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => TestResultPos(
                                      highestClass: highestClass,
                                      highestConfidence: confidencePercentage,
                                    ),
                              ),
                            );
                          } catch (e) {}
                          setState(() {
                            isLoading = false;
                          });
                        } else if (confidencePercentage <= 0) {
                          Navigator.pushReplacementNamed(
                            context,
                            TestResultNeg.id,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff194D59),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        fixedSize: Size(screenWidth * 0.6, 45),
                      ),
                      child: Text(
                        'Test',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> classifyImageAPI(File imageFile) async {
    const String apiUrl =
        "https://classify.roboflow.com/skin-cancer-classification-kjic2/1";
    const String apiKey = "7WLPkvlSOmN6weWa51Eq";

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$apiUrl?api_key=$apiKey"),
      );
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var result = jsonDecode(responseData);

        Map<String, dynamic> data = result;
        Map<String, dynamic> predictions = data['predictions'];

        predictions.forEach((key, value) {
          double confidence = value['confidence'];
          if (confidence > highestConfidence) {
            highestConfidence = confidence;
            highestClass = key;
          }
        });
        confidencePercentage = (highestConfidence * 100).round();
        print('Highest Class: $highestClass');
        print('Highest Confidence: ${highestConfidence * 100}');
      } else {
        print("Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Exception: $e");
    }
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
