import 'package:canser_scan/helper/constants.dart';
import 'package:flutter/material.dart';
import 'map_page.dart';

class Doctor {
  final String image;
  final String name;
  final String governorate;
  final String region;
  final double lat;
  final double lng;

  Doctor({
    required this.image,
    required this.name,
    required this.governorate,
    required this.region,
    required this.lat,
    required this.lng,
  });
}

class DoctorDetailsPage extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailsPage({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          doctor.name,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    doctor.image,
                    fit: BoxFit.cover,
                    height: screenHeight * 0.3,
                    width: screenWidth * 0.6,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          height: screenHeight * 0.3,
                          width: screenWidth * 0.6,
                          color: Colors.grey[300],
                          child: const Icon(Icons.person, size: 100),
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Doctor Name
              Text(
                doctor.name,
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              // Location Info
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: screenWidth * 0.05,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '${doctor.region}, ${doctor.governorate}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Map Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MapPage(
                              doctorLatfdp: doctor.lat,
                              doctorLngfdp: doctor.lng,
                            ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View on Map',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Image.asset('assets/photos/mapicon.png', height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
