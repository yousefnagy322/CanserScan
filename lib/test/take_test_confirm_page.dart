// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:canser_scan/test/take_test_page.dart';
import 'package:canser_scan/test/test_result_neg.dart';
import 'package:canser_scan/test/test_result_pos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
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
  String highestClassApi = '';
  int confidencePercentageApi = 0;
  double highestConfidenceApi = 0;

  String highestClassModel = '';
  int confidencePercentageModel = 0;
  double highestConfidenceModel = 0;

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
                            await classifyImageModel(widget.imageFile!);

                            if (highestClassModel == "Unknown" ||
                                confidencePercentageApi < 50) {
                              saveTestResult("Negative");
                              Navigator.pushReplacementNamed(
                                context,
                                TestResultNeg.id,
                              );
                            } else {
                              saveTestResult('Positive');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => TestResultPos(
                                        highestClassApi: highestClassApi,
                                        highestConfidenceApi:
                                            confidencePercentageApi,
                                        highestClassModel: highestClassModel,
                                        highestConfidenceModel:
                                            confidencePercentageModel,
                                      ),
                                ),
                              );
                            }
                          } catch (e) {
                            print(e);
                          }
                          setState(() {
                            isLoading = false;
                          });
                        } else {
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

  Future<void> saveTestResult(String result) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user logged in!");
      return;
    }

    // Firestore references
    DocumentReference userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    CollectionReference testResults = userDoc.collection('Test_Results');
    DocumentReference latestTestDoc = userDoc
        .collection('Latest_Test_Results')
        .doc('Latest');

    Map<String, dynamic> testData = {
      'Result': result,
      'prediction': highestClassApi,
      'confidence': confidencePercentageModel,
      'timestamp': FieldValue.serverTimestamp(),
    };

    // Perform batch write: Save in subcollection & update latest test document
    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.set(testResults.doc(), testData); // Add to Test Results
    batch.set(latestTestDoc, testData); // Overwrite latest result

    await batch.commit();
    print("Test result saved & latest test updated!");
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
          if (confidence > highestConfidenceApi) {
            highestConfidenceApi = confidence;
            highestClassApi = key;
          }
        });
        confidencePercentageApi = (highestConfidenceApi * 100).round();
        print('Highest ClassApi: $highestClassApi');
        print('Highest ConfidenceApi: ${highestConfidenceApi * 100}');
      } else {
        print("Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  Future<void> classifyImageModel(File imageFile) async {
    final interpreter = await Interpreter.fromAsset(
      'assets/model_unquant.tflite',
    );
    final labels = await rootBundle
        .loadString('assets/labels.txt')
        .then((value) => value.split('\n'));

    // Load and preprocess image
    img.Image? image = img.decodeImage(await imageFile.readAsBytes());
    if (image == null) {
      print("Error decoding image");
      return;
    }
    image = img.copyResize(image, width: 224, height: 224);

    // Convert image to float32 tensor with normalization (-1 to 1)
    var input = List.generate(
      224,
      (y) => List.generate(224, (x) {
        final pixel = image!.getPixel(x, y);
        return [
          (pixel.r.toDouble() - 127.5) / 127.5,
          (pixel.g.toDouble() - 127.5) / 127.5,
          (pixel.b.toDouble() - 127.5) / 127.5,
        ];
      }),
    );

    var inputTensor = [input]; // Shape: [1, 224, 224, 3]
    var outputTensor = List.filled(1 * 9, 0.0).reshape([1, 9]);

    // Run inference
    interpreter.run(inputTensor, outputTensor);

    // Get highest confidence label
    List<double> confidences = outputTensor[0];

    for (int i = 0; i < confidences.length; i++) {
      if (confidences[i] > highestConfidenceModel) {
        highestConfidenceModel = confidences[i];
        highestClassModel = labels[i];
      }
    }

    confidencePercentageModel = (highestConfidenceModel * 100).round();
    print('Highest ClassModel: $highestClassModel');
    print('Highest ConfidenceModel: $confidencePercentageModel%');
  }

  List<double> imageToByteListFloat32(
    img.Image image,
    int inputSize,
    double mean,
    double std,
  ) {
    // Convert image to byte list and normalize
    var convertedBytes = Float32List(inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var y = 0; y < inputSize; y++) {
      for (var x = 0; x < inputSize; x++) {
        var pixel = image.getPixel(x, y);
        buffer[pixelIndex++] = (pixel.r - mean) / std; // Red component
        buffer[pixelIndex++] = (pixel.g - mean) / std; // Green component
        buffer[pixelIndex++] = (pixel.b - mean) / std; // Blue component
      }
    }
    return convertedBytes;
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Image.file(widget.imageFile!, fit: BoxFit.fill),
          ),
          Image.asset(image, scale: 1.5),
        ],
      ),
    );
  }
}
